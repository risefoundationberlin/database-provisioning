########################################
# Azure Database for PostgreSQL - Main #
########################################

provider "azurerm" {
  features {}
}

# import existing subnet of aks cluster
data "azurerm_subnet" "aks-subnet" {
  name                 = var.aks-vnet-subnet
  virtual_network_name = var.aks-vnet
  resource_group_name  = var.aks-vnet-resource-group
}

# Create a PostgreSQL server
resource "azurerm_postgresql_server" "postgresql-server" {
  name                = "rf-postgresql-server"
  location            = var.location
  resource_group_name = var.postgres-resource-group

  administrator_login          = var.postgresql-admin-login
  administrator_login_password = var.postgresql-admin-password

  sku_name = var.postgresql-sku-name
  version  = var.postgresql-version

  storage_mb        = var.postgresql-storage
  auto_grow_enabled = true

  backup_retention_days            = 7
  geo_redundant_backup_enabled     = false
  public_network_access_enabled    = true
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
  tags = {
    Environment = "Production"
  }
}

# Create a PostgreSQL database
resource "azurerm_postgresql_database" "postgresql-db" {
  name                = "event-management"
  resource_group_name = var.postgres-resource-group
  server_name         = azurerm_postgresql_server.postgresql-server.name
  charset             = "utf8"
  collation           = "English_United States.1252"

}

# Create a PostgreSQL firewall rule
resource "azurerm_postgresql_firewall_rule" "firewall_rule_aks" {
  name                = "firewall_rule_aks"
  resource_group_name = var.postgres-resource-group
  server_name         = azurerm_postgresql_server.postgresql-server.name
  start_ip_address    = "10.244.0.0"
  end_ip_address      = "10.244.0.255"
}