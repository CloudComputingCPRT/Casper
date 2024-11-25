/* -------------------------------------------------------------------------- */
/*          Main Terraform configuration file for the Casper project.         */
/* -------------------------------------------------------------------------- */

# Azure Resource Group
data "azurerm_subscription" "current" {
}

# Azure AD User
data "azuread_user" "user" {
  user_principal_name = var.email_address
}

# Resource Group
resource "azurerm_resource_group" "casper" {
  name     = var.resource_group_name # Resource group name
  location = var.location  # Azure region
}

locals {
  resource_group = azurerm_resource_group.casper.name
  location       = azurerm_resource_group.casper.location
  app_name       = "api-casper"
}

/* ------------------------------- API Service ------------------------------ */
module "api_service" {
  source = "./modules/app_service" # Path to the app service module
  count  = var.enable_api ? 1 : 0

  resource_group_name = local.resource_group 
  location            = local.location

  app_name            = local.app_name
  pricing_plan        = "B1" # Basic tier
  docker_image        = "cloudcomputingcprt/casper/pre_release_image:latest" # Docker image
  docker_registry_url = "https://ghcr.io" # GitHub Container Registry (where the image is stored)

  # Environment variables
  app_settings = {
    # Database credentials
    DATABASE_HOST     = local.database_connection.host 
    DATABASE_PORT     = local.database_connection.port
    DATABASE_NAME     = local.database.name
    DATABASE_USER     = local.database.username
    DATABASE_PASSWORD = local.database.password

    # Storage credentials
    STORAGE_ACCOUNT_URL = local.storage_url

    # New Relic monitoring credentials
    # TODO: Replace with your own New Relic license key
    NEW_RELIC_LICENSE_KEY = var.new_relic_licence_key
    NEW_RELIC_APP_NAME    = local.app_name
  }
}

/* --------------------------- PostgreSQL Database -------------------------- */
module "database" {
  source = "./modules/database" # Path to the database module
  count  = var.enable_database ? 1 : 0

  resource_group_name = local.resource_group
  location            = local.location

  # Database ownership details
  entra_administrator_tenant_id      = data.azurerm_subscription.current.tenant_id
  entra_administrator_object_id      = data.azuread_user.user.object_id
  entra_administrator_principal_type = "User"
  entra_administrator_principal_name = data.azuread_user.user.user_principal_name

  # Database configuration credentials
  server_name                     = local.database.server_name
  database_administrator_login    = local.database.username
  database_administrator_password = local.database.password
  database_name                   = local.database.name
}

locals {
  database_connection = {
    # Database connection details
    host = try(module.database[0].server_address, null)
    port = try(module.database[0].port, null)
  }
}

/* ------------------------------ Blob Storage ------------------------------ */
module "api_storage" {
  source = "./modules/storage" # Path to the storage module
  count  = var.enable_storage ? 1 : 0

  resource_group_name  = local.resource_group
  location             = local.location
  storage_account_name = local.storage.name
  container_name       = "api"

  service_principal_id = var.enable_storage_read_for_api ? module.api_service[0].principal_id : null
  user_principal_id    = var.enable_storage_read_for_user ? data.azuread_user.user.object_id : null
}

locals {
  storage_url = try(module.api_storage[0].url, null)
}