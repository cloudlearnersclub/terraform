terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "68d12938-6cd4-4f41-a3f3-5818261601e4"
  tenant_id = "57135b04-f0d0-4240-af74-1c11947a9f26"
  client_id = "08a5f095-f4b5-41f0-a334-c8d561bd8f18"
  client_secret = "qNd8Q~F6nQ8tbEBRoPXDtsFsG0EMnibyw089dbpP"
  skip_provider_registration = true
  features {}  
}
