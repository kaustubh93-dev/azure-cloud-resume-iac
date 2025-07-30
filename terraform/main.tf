# =============================================================================
# DATA SOURCES
# =============================================================================
# Get current Azure client configuration (user/service principal info)
data "azurerm_client_config" "current" {}

# =============================================================================
# RANDOM RESOURCE GENERATION
# =============================================================================
# Generate a random name suffix for the resource group to ensure uniqueness
# Format: {prefix}-{random-animal-name}
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

# Generate a random string for storage account name (must be globally unique)
# Azure storage account names must be 3-24 characters, lowercase, and numeric only
resource "random_string" "storage_account_name" {
  length  = 8
  lower   = true
  numeric = false  # Only letters, no numbers
  special = false  # No special characters
  upper   = false  # No uppercase letters
}

# =============================================================================
# AZURE RESOURCE GROUP
# =============================================================================
# Create the main resource group that will contain all our resources
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location  # Azure region (e.g., "eastus")
  name     = random_pet.rg_name.id        # Uses the random name generated above
  
  # Tags for resource organization and cost tracking
  tags = {
    environment = "staging"
    created_by  = data.azurerm_client_config.current.object_id
  }
}

# =============================================================================
# AZURE STORAGE ACCOUNT
# =============================================================================
# Create storage account that will host our static website
# StorageV2 is required for static website hosting
resource "azurerm_storage_account" "storage_account" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = random_string.storage_account_name.result

  account_tier             = "Standard"  # Standard performance tier
  account_replication_type = "LRS"       # Locally Redundant Storage (cheapest option)
  account_kind             = "StorageV2" # General Purpose v2 (required for static websites)
  
  tags = {
    environment = "staging"
    created_by  = data.azurerm_client_config.current.object_id
  }
}

# =============================================================================
# STATIC WEBSITE CONFIGURATION
# =============================================================================
# Enable static website hosting on the storage account
# This creates the $web container automatically
resource "azurerm_storage_account_static_website" "static_website" {
  storage_account_id = azurerm_storage_account.storage_account.id
  index_document     = "index.html"     # Default page to serve
  error_404_document = "not_found.html" # Custom 404 error page (optional)
}

# =============================================================================
# FILE DISCOVERY AND PROCESSING
# =============================================================================
# Local values for processing frontend files
locals {
  # Use fileset() to recursively find all files in the frontend directory
  # "**/*" pattern matches all files in all subdirectories
  frontend_files = fileset("${path.module}/../frontend", "**/*")
  
  # Filter the results to include only actual files (not directories)
  # fileexists() checks if the path points to a file, not a directory
  frontend_file_list = [
    for file in local.frontend_files : file
    if fileexists("${path.module}/../frontend/${file}")
  ]
}

# =============================================================================
# BLOB UPLOAD - FRONTEND FILES
# =============================================================================
# Upload all files from the frontend directory to Azure Storage
# Uses for_each to create one blob resource per file
resource "azurerm_storage_blob" "frontend_files" {
  # Convert list to set for for_each (required by Terraform)
  for_each = toset(local.frontend_file_list)
  
  # Blob configuration
  name                   = each.value                                    # Preserves relative path as blob name
  storage_account_name   = azurerm_storage_account.storage_account.name  # Target storage account
  storage_container_name = "$web"                                        # Static website container
  type                   = "Block"                                       # Block blob type (standard for files)
  source                = "${path.module}/../frontend/${each.value}"     # Local file path
  
  # Automatically determine MIME type based on file extension
  # This is crucial for browsers to handle files correctly
  content_type = lookup(
    var.content_type_map,                                               # Our content type mapping variable
    lower(split(".", each.value)[length(split(".", each.value)) - 1]), # Extract and lowercase file extension
    "application/octet-stream"                                          # Default fallback content type
  )
  
  # Ensure static website is configured before uploading files
  depends_on = [azurerm_storage_account_static_website.static_website]
}

# =============================================================================
# AZURE FRONT DOOR PROFILE
# =============================================================================
# Create Azure Front Door profile for CDN and global load balancing
# Standard tier provides essential CDN features with good performance
resource "azurerm_cdn_frontdoor_profile" "frontdoor_profile" {
  name                = var.frontdoor_profile_name
  resource_group_name = azurerm_resource_group.rg.name
  sku_name           = "Standard_AzureFrontDoor"  # Standard pricing tier
  
  tags = {
    environment = "staging"
    created_by  = data.azurerm_client_config.current.object_id
  }
}

# =============================================================================
# AZURE FRONT DOOR ENDPOINT
# =============================================================================
# Create Front Door endpoint - this will be the public-facing URL
# The endpoint hostname is automatically generated by Azure
resource "azurerm_cdn_frontdoor_endpoint" "frontdoor_endpoint" {
  name                     = var.frontdoor_endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile.id
  
  tags = {
    environment = "staging"
    created_by  = data.azurerm_client_config.current.object_id
  }
}

# =============================================================================
# AZURE FRONT DOOR ORIGIN GROUP
# =============================================================================
# Define origin group for load balancing and health checks
# Groups multiple origins together for redundancy
resource "azurerm_cdn_frontdoor_origin_group" "frontdoor_origin_group" {
  name                     = "${var.frontdoor_endpoint_name}-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.frontdoor_profile.id
  
  # Load balancing settings
  load_balancing {
    additional_latency_in_milliseconds = 50     # Max acceptable additional latency
    sample_size                       = 4      # Number of samples for latency measurement
    successful_samples_required       = 3      # Required successful samples
  }
  
  # Health probe configuration to monitor origin health
  health_probe {
    path                = "/"                   # Health check endpoint
    request_type        = "HEAD"               # HTTP method for health checks
    protocol            = "Https"              # Use HTTPS for security
    interval_in_seconds = 100                  # Health check frequency
  }
}

# =============================================================================
# AZURE FRONT DOOR ORIGIN
# =============================================================================
# Define the origin (static website) that Front Door will route traffic to
# This points to the Azure Storage static website endpoint
resource "azurerm_cdn_frontdoor_origin" "frontdoor_origin" {
  name                          = "${var.frontdoor_endpoint_name}-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.frontdoor_origin_group.id
  
  enabled                        = true
  host_name                     = azurerm_storage_account.storage_account.primary_web_host   
  http_port                     = 80
  https_port                    = 443
  origin_host_header            = azurerm_storage_account.storage_account.primary_web_host   
  priority                      = 1      # Origin priority (1 = highest)
  weight                        = 1000   # Traffic weight distribution
  certificate_name_check_enabled = true  # Enable certificate name checking
  
  depends_on = [azurerm_storage_account_static_website.static_website]
}

# =============================================================================
# AZURE FRONT DOOR ROUTE
# =============================================================================
# Configure routing rules to direct incoming requests to the origin
# This defines how traffic flows from the endpoint to your static website
resource "azurerm_cdn_frontdoor_route" "frontdoor_route" {
  name                          = "${var.frontdoor_endpoint_name}-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.frontdoor_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.frontdoor_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.frontdoor_origin.id]
  
  # Route configuration
  supported_protocols    = ["Http", "Https"]   # Accept both HTTP and HTTPS
  patterns_to_match     = ["/*"]               # Match all paths
  forwarding_protocol   = "HttpsOnly"          # Always use HTTPS to origin
  link_to_default_domain = true                # Enable default *.azurefd.net domain
  https_redirect_enabled = true                # Redirect HTTP to HTTPS
  
  # Cache configuration for static content
  cache {
    query_string_caching_behavior = "IgnoreQueryString"  # Cache regardless of query params
    query_strings                = []
    compression_enabled          = true                   # Enable gzip compression
    content_types_to_compress = [
      "application/eot",
      "application/font",
      "application/font-sfnt",
      "application/javascript",
      "application/json",
      "application/opentype",
      "application/otf",
      "application/pkcs7-mime",
      "application/truetype",
      "application/ttf",
      "application/vnd.ms-fontobject",
      "application/xhtml+xml",
      "application/xml",
      "application/xml+rss",
      "application/x-font-opentype",
      "application/x-font-truetype",
      "application/x-font-ttf",
      "application/x-httpd-cgi",
      "application/x-javascript",
      "application/x-mpegurl",
      "application/x-opentype",
      "application/x-otf",
      "application/x-perl",
      "application/x-ttf",
      "font/eot",
      "font/ttf",
      "font/otf",
      "font/opentype",
      "image/svg+xml",
      "text/css",
      "text/csv",
      "text/html",
      "text/javascript",
      "text/js",
      "text/plain",
      "text/richtext",
      "text/tab-separated-values",
      "text/xml",
      "text/x-script",
      "text/x-component",
      "text/x-java-source"
    ]
  }
}