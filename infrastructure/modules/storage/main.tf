/* -------------------------------------------------------------------------- */
/*                             Blob Storage Module                            */
/* -------------------------------------------------------------------------- */

# Create a storage account, container, and blob storage
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Create a storage container
resource "azurerm_storage_container" "container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

# Assign the Storage Blob Data Reader role to the service principal
resource "azurerm_role_assignment" "service_binding" {
  # count = var.service_principal_id != null ? 1 : 0

  scope                = resource.azurerm_storage_container.container.resource_manager_id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = var.service_principal_id
}

# Assign the Storage Blob Data Reader role to the user
resource "azurerm_role_assignment" "user_binding" {
  count = var.user_principal_id != null ? 1 : 0

  scope                = resource.azurerm_storage_container.container.resource_manager_id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = var.user_principal_id
}

# Create a blob storage
# This will upload the quotes.json file to the blob storage
# The quotes.json file contains a list of quotes that will be used by the API
resource "azurerm_storage_blob" "blob_storage" {
  name                   = "quotes.json" # Name of the blob storage
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = resource.azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "${path.module}/quotes.json" # Path to the quotes.json file
}