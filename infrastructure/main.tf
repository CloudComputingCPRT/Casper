terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.3.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = ""
}

resource "azurerm_resource_group" "casper" {
  name     = "Casper"
  location = "francecentral"
}