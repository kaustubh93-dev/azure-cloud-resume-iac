# Azure Static Website Deployment with Terraform

This Terraform configuration automatically deploys a static website to Azure Storage, uploading all files from your frontend directory to a globally accessible web endpoint.

## 🏗️ Architecture Overview

```
📁 Project Structure
├── 📁 frontend/         # Your static website files
│   ├── index.html        # Main page
│   ├── 📁 css/          # Stylesheets
│   ├── 📁 js/           # JavaScript files
│   ├── 📁 fonts/        # Font files
│   └── 📁 sass/         # SASS/SCSS files
└── 📁 terraform/        # Infrastructure as Code
    ├── main.tf          # Main configuration
    ├── outputs.tf       # Desired output file
    ├── providers.tf     # Azure provider used
    ├── variables.tf     # Variable definitions
    └── README.md        # This file
```

## 🚀 What This Creates

- **Azure Resource Group** - Container for all resources
- **Azure Storage Account** - Hosts your static website
- **Static Website Configuration** - Enables web hosting on storage
- **Blob Storage** - Uploads all frontend files with proper MIME types

## 📋 Prerequisites

### Required Tools
- [Terraform](https://terraform.io/downloads) (>= 1.0)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription with appropriate permissions

### Azure Permissions Required
- Resource Group: Create, Read, Update, Delete
- Storage Account: Create, Read, Update, Delete
- Storage Blob: Create, Read, Update, Delete

## 🔧 Setup Instructions

### 1. Azure Authentication
```bash
# Login to Azure
az login

# Set your subscription (if you have multiple)
az account set --subscription "your-subscription-id"

# Verify current account
az account show
```

### 2. Initialize Terraform
```bash
cd terraform
terraform init -upgrade
```

### 3. Review and Customize Variables
Edit `variables.tf` or create a `terraform.tfvars` file:

```hcl
# terraform.tfvars (optional)
resource_group_location = "eastus"
resource_group_name_prefix = "mywebsite"
```

### 4. Plan Deployment
```bash
terraform plan -out main.tfplan
```

### 5. Deploy Infrastructure
```bash
terraform apply main.tfplan
```

## 📁 Supported File Types

The configuration automatically handles these file types with proper MIME types:

| Extension | MIME Type | Description |
|-----------|-----------|-------------|
| `.html`, `.htm` | `text/html` | HTML pages |
| `.css` | `text/css` | Stylesheets |
| `.js` | `application/javascript` | JavaScript |
| `.json` | `application/json` | JSON data |
| `.png`, `.jpg`, `.gif` | `image/*` | Images |
| `.svg` | `image/svg+xml` | Vector graphics |
| `.woff`, `.woff2`, `.ttf` | `font/*` | Web fonts |
| `.pdf` | `application/pdf` | PDF documents |
| `.scss`, `.sass` | `text/x-scss` | SASS files |

*Note: Unknown file types default to `application/octet-stream`*

## 🌐 Accessing Your Website

After deployment, Terraform outputs the website URL:

```bash
# Get the static website URL
terraform output static_website_url
```

Or find it in the Azure Portal:
1. Go to your Storage Account
2. Navigate to **Static website** under **Data management**
3. Copy the **Primary endpoint** URL

## 📝 Configuration Details

### Resource Naming
- **Resource Group**: `{prefix}-{random-animal-name}` (e.g., `mywebsite-flying-whale`)
- **Storage Account**: `{8-random-lowercase-letters}` (e.g., `abcdefgh`)

### File Upload Process
1. **Discovery**: `fileset()` recursively finds all files in `../frontend`
2. **Filtering**: Only actual files are included (directories excluded)
3. **Upload**: Each file uploaded with preserved directory structure
4. **MIME Types**: Automatically assigned based on file extension

### Storage Configuration
- **Performance Tier**: Standard
- **Replication**: LRS (Locally Redundant Storage)
- **Account Kind**: StorageV2 (required for static websites)

## 🔄 Managing Updates

### Update Website Content
After modifying files in the `frontend` directory:

```bash
cd terraform
terraform plan
terraform apply
```

Terraform will automatically:
- Detect changed files
- Upload new/modified files
- Remove deleted files
- Update MIME types if needed

### Add New File Types
To support additional file extensions, update the `content_type_map` in `variables.tf`:

```hcl
variable "content_type_map" {
  type = map(string)
  default = {
    # ... existing types ...
    mp4  = "video/mp4"
    webm = "video/webm"
    # Add your custom types here
  }
}
```

## 🧹 Cleanup

To list resources to be destroyed

```bash
terraform plan -destroy -out main.destroy.tfplan
```

This will destroy all created resources:

```bash
terraform apply main.destroy.tfplan
```

**⚠️ Warning**: This will permanently delete your storage account and all uploaded files.

## 🛠️ Troubleshooting

### Common Issues

#### Storage Account Name Conflicts
**Problem**: "Storage account name is already taken"
**Solution**: Run `terraform apply` again - the random name generator will create a new unique name.

#### File Upload Failures
**Problem**: Some files not uploading
**Solution**: 
1. Check file permissions in the `frontend` directory
2. Ensure files aren't binary or corrupted
3. Verify the `frontend` directory path is correct

#### MIME Type Issues
**Problem**: Files not displaying correctly in browser
**Solution**: Add the file extension to `content_type_map` in `variables.tf`

### Debug Commands
```bash
# Show current state
terraform show

# List all resources
terraform state list

# Get specific resource details
terraform state show azurerm_storage_account.storage_account

# Refresh state from Azure
terraform refresh
```

## 📊 Cost Estimation

Typical monthly costs for a small static website:
- **Storage Account**: ~$1-5/month
- **Bandwidth**: ~$0.05-0.50/month (first 5GB free)
- **Operations**: ~$0.01-0.10/month

*Costs vary by region and usage. Use [Azure Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/) for accurate estimates.*

## 🔐 Security Considerations

- Storage account has public read access for static website hosting
- Consider enabling HTTPS custom domain for production use
- Review Azure Storage security best practices
- Use Azure CDN for better performance and security

## 📚 Additional Resources

- [Azure Static Website Hosting](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website)
- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
- [Azure Storage Security Guide](https://docs.microsoft.com/en-us/azure/storage/common/storage-security-guide)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with `terraform plan`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.