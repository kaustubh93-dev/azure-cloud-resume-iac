# =============================================================================
# OUTPUT VALUES
# =============================================================================
# These outputs provide important information after deployment

# Static website direct URL (without CDN)
output "static_website_url" {
  description = "The primary web endpoint URL of the static website (direct storage access)"
  value       = azurerm_storage_account.storage_account.primary_web_endpoint
}

# Storage account name for reference
output "storage_account_name" {
  description = "The name of the created storage account"
  value       = azurerm_storage_account.storage_account.name
}

# Resource group name for reference
output "resource_group_name" {
  description = "The name of the created resource group"
  value       = azurerm_resource_group.rg.name
}

# Front Door Profile information
output "frontdoor_profile_name" {
  description = "The name of the Azure Front Door profile"
  value       = azurerm_cdn_frontdoor_profile.frontdoor_profile.name
}

output "frontdoor_profile_id" {
  description = "The ID of the Azure Front Door profile"
  value       = azurerm_cdn_frontdoor_profile.frontdoor_profile.id
}

# Front Door Endpoint information (this is your main website URL)
output "frontdoor_endpoint_hostname" {
  description = "The hostname of the Front Door endpoint (your primary website URL)"
  value       = azurerm_cdn_frontdoor_endpoint.frontdoor_endpoint.host_name
}

output "frontdoor_endpoint_url" {
  description = "The full HTTPS URL of your website via Front Door CDN"
  value       = "https://${azurerm_cdn_frontdoor_endpoint.frontdoor_endpoint.host_name}"
}

# Origin information
output "frontdoor_origin_hostname" {
  description = "The origin hostname (static website) that Front Door routes to"
  value       = azurerm_cdn_frontdoor_origin.frontdoor_origin.host_name
}