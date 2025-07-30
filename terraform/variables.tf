variable "resource_group_location" {
  type        = string
  description = "Location of the resource group."
  default     = "eastus"
}

variable "resource_group_name_prefix" {
  type        = string
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
  default     = "rg"
}

variable "frontdoor_profile_name" {
  type        = string
  description = "Name of the Azure Front Door profile."
  default     = "mywebsite-frontdoor-profile"
}

variable "frontdoor_endpoint_name" {
  type        = string
  description = "Name of the Azure Front Door endpoint."
  default     = "mywebsite-endpoint"
}

variable "content_type_map" {
  type = map(string)
  default = {
    html  = "text/html; charset=utf-8"
    htm   = "text/html; charset=utf-8"
    css   = "text/css; charset=utf-8"
    js    = "application/javascript; charset=utf-8"
    json  = "application/json; charset=utf-8"
    png   = "image/png"
    jpg   = "image/jpeg"
    jpeg  = "image/jpeg"
    gif   = "image/gif"
    svg   = "image/svg+xml"
    webp  = "image/webp"
    ico   = "image/x-icon"
    woff  = "font/woff"
    woff2 = "font/woff2"
    ttf   = "font/ttf"
    otf   = "font/otf"
    eot   = "application/vnd.ms-fontobject"
    txt   = "text/plain; charset=utf-8"
    md    = "text/markdown; charset=utf-8"
    xml   = "application/xml; charset=utf-8"
    pdf   = "application/pdf"
    zip   = "application/zip"
    # SASS/SCSS files (though they should be compiled to CSS)
    scss  = "text/x-scss; charset=utf-8"
    sass  = "text/x-sass; charset=utf-8"
  }
}