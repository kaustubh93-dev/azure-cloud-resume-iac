# ☁️ Azure Cloud Resume - Infrastructure as Code

Terraform configuration to provision the full Azure infrastructure for the [Cloud Resume Challenge](https://cloudresumechallenge.dev/) — a static resume website served globally via Azure Front Door with HTTPS and GZIP compression.

## 🏗️ Architecture

```
Azure Storage Account (Static Website)
        │
        ▼
Azure Front Door (Standard SKU)
   ┌────┴────┐
   │ CDN     │ HTTPS-only
   │ GZIP    │ Global edge delivery
   └────┬────┘
        ▼
      User
```

Terraform creates a **Resource Group**, a **Storage Account** with static website hosting enabled, automatically uploads all frontend files with correct MIME types, and provisions an **Azure Front Door** profile with endpoint, origin group, origin, and route — enforcing HTTPS-only access with compression for 30+ content types.

## 📁 Project Structure

```
azure-cloud-resume-iac/
├── README.md
├── LICENSE                 # MIT
├── frontend/               # Static website (HTML5 UP Aerial template)
│   ├── index.html
│   ├── css/
│   ├── js/
│   ├── fonts/
│   └── sass/
└── terraform/
    ├── main.tf             # All resource definitions
    ├── variables.tf        # Input variables & MIME type map
    ├── outputs.tf          # Deployment outputs
    ├── providers.tf        # Provider config (azurerm, random)
    └── terraform_readme.md
```

## 🛠️ Tech Stack

| Layer          | Technology                                  |
| -------------- | ------------------------------------------- |
| IaC            | Terraform >= 1.0 (`azurerm ~> 3.0`)        |
| Hosting        | Azure Storage Account (StorageV2, LRS)      |
| CDN / Routing  | Azure Front Door (Standard_AzureFrontDoor)  |
| Frontend       | HTML5 UP Aerial template                    |

## 🚀 Deployment

### Prerequisites

- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) — authenticated (`az login`)
- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0

### Steps

```bash
# 1. Clone the repo
git clone https://github.com/kaustubh93-dev/azure-cloud-resume-iac.git
cd azure-cloud-resume-iac/terraform

# 2. Initialize Terraform
terraform init

# 3. Preview the infrastructure changes
terraform plan

# 4. Deploy (creates all resources and uploads frontend files)
terraform apply
```

After `apply` completes, Terraform outputs the Front Door URL where your resume is live.

## 📋 Terraform Variables

| Variable                   | Description                          | Default    |
| -------------------------- | ------------------------------------ | ---------- |
| `resource_group_location`  | Azure region for all resources       | `eastus`   |
| `frontdoor_profile_name`   | Name of the Front Door profile       | —          |
| `frontdoor_endpoint_name`  | Name of the Front Door endpoint      | —          |
| `content_type_map`         | File extension → MIME type mapping   | 30+ types  |

## 📤 Outputs

| Output                       | Description                              |
| ---------------------------- | ---------------------------------------- |
| `static_website_url`         | Storage Account static website URL       |
| `storage_account_name`       | Name of the created Storage Account      |
| `resource_group_name`        | Name of the created Resource Group       |
| `frontdoor_endpoint_hostname`| Front Door endpoint hostname             |
| `frontdoor_endpoint_url`     | Full HTTPS URL to access the resume      |

## 🔗 Related

- [azure-resume-challenge](../azure-resume-challenge/) — Main resume app with Azure Functions backend and Cosmos DB visitor counter.

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.