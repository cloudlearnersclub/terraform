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
  client_id = "c635ab76-70eb-4a2f-bea8-e68cdfcfcafe"
  client_secret = "1AE8Q~DDBfQ9HW5pQ2eJY0hwOoDk.-dgEoWZwdrp"
  skip_provider_registration = true
  features {}  
}
