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
  subscription_id = var.subscription_id
}


resource "random_integer" "ri" {
  min = 0
  max = 10000
}


resource "azurerm_resource_group" "rg" {
  name     = "Casper-rg-${random_integer.ri.id}"
  location = var.location
}


resource "azurerm_storage_account" "storacc" {
  name                     = "storacc${random_integer.ri.id}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_service_plan" "example" {
  name                = "service-plan-${random_integer.ri.id}" //Change this for more clarity
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}


resource "azurerm_linux_web_app" "app_service" {
  name                = "web-app-${random_integer.ri.id}" // var.app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.example.id
  app_settings        = var.app_settings

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = var.pricing_plan != "F1"

    application_stack {
      docker_registry_url = var.docker_registry_url
      docker_image_name   = var.docker_image
    }
  }

  logs {
    http_logs {
      file_system {
        retention_in_days = 1
        retention_in_mb   = 50
      }
    }
  }
}
