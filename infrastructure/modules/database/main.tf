/* -------------------------------------------------------------------------- */
/*                         PostgreSQL Flexible Server                         */
/* -------------------------------------------------------------------------- */

# Create a PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "postgresql_database" {
  administrator_login           = var.database_administrator_login
  administrator_password        = var.database_administrator_password
  auto_grow_enabled             = false # Disabling auto-grow to prevent unexpected costs
  backup_retention_days         = 7 # Retain backups for 7 days
  geo_redundant_backup_enabled  = false # Disabling geo-redundant backups to prevent unexpected costs
  location                      = var.location # Use the same location as the resource group
  name                          = var.server_name # Name of the PostgreSQL Flexible Server
  public_network_access_enabled = true # Disable public network access
  resource_group_name           = var.resource_group_name # Use the same resource group as the other resources
  sku_name                      = "B_Standard_B1ms" # Basic tier with 1 vCore and 2 GB memory
  storage_tier                  = "P4" 
  storage_mb                    = "32768" # 32 GB of storage
  version                       = "16" # PostgreSQL 16
  zone                          = "1"

  # Enable Active Directory authentication and password authentication
  authentication {
    active_directory_auth_enabled = true # Enable Active Directory authentication
    password_auth_enabled         = true # Enable password authentication
    tenant_id                     = var.entra_administrator_tenant_id # Tenant ID of the Active Directory
  }
}

# Create an Active Directory administrator for the PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server_active_directory_administrator" "administrator" {
  tenant_id           = var.entra_administrator_tenant_id # Tenant ID of the Active Directory
  resource_group_name = var.resource_group_name # Use the same resource group as the other resources
  server_name         = azurerm_postgresql_flexible_server.postgresql_database.name
  principal_type      = var.entra_administrator_principal_type # Principal type (User or Group)
  object_id           = var.entra_administrator_object_id # Object ID of the Active Directory user
  principal_name      = var.entra_administrator_principal_name 
}

# Create a firewall rule to allow all IP addresses
# This is only for demonstration purposes and should not be used in production
# Basically, this allows all IP addresses to connect to the PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  name             = "AllowAll" # Name of the firewall rule
  server_id        = azurerm_postgresql_flexible_server.postgresql_database.id # ID of the PostgreSQL Flexible Server
  start_ip_address = "0.0.0.0" # Start IP address
  end_ip_address   = "255.255.255.255" # End IP address
}

# Create a PostgreSQL Flexible Server database
resource "azurerm_postgresql_flexible_server_database" "database" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.postgresql_database.id
}