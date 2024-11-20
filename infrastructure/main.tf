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
  name     = "rg${random_integer.storage_name.id}"
  location = "francecentral"
}


resource "random_integer" "storage_name" {
  min = 0
  max = 10000
}


resource "azurerm_storage_account" "storacc" {
  name                     = "storacc${random_integer.storage_name.id}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_service_plan" "example" {
  name                = "serviceplan${random_integer.storage_name.id}" //Change this for more clarity 
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  os_type             = "Windows"
  sku {
    tier = "Basic"     #Double check this
    size = "B1"   
  }
}


resource "azurerm_windows_web_app" "example" {
  name                = "webapp${random_integer.storage_name.id}" 
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_service_plan.example.location
  service_plan_id     = azurerm_service_plan.example.id

  //site_config {}    Maybe activate this in order to complete the deploy 
}



