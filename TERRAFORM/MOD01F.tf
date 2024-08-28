## MOD-01-F-POSTGRESQL
resource "azurerm_postgresql_server" "lab01f" {
  name                = "${local.lab01f_name}-postgre-svr-${local.random_str}"
  location            = azurerm_resource_group.dp300.location
  resource_group_name = azurerm_resource_group.dp300.name

  sku_name   = "B_Gen5_1"
  storage_mb = 8192
  version    = "11"

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = var.user_name
  administrator_login_password = var.user_passowrd

  public_network_access_enabled    = true
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"

  tags = {
    environment = local.group_name
  }
}

resource "azurerm_postgresql_database" "lab01f" {
  name                = "${local.lab01f_name}-postgre-db-${local.random_str}"
  resource_group_name = azurerm_resource_group.dp300.name
  server_name         = azurerm_postgresql_server.lab01f.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_postgresql_firewall_rule" "lab01f01" {
  name                = "Money"
  resource_group_name = azurerm_resource_group.dp300.name
  server_name         = azurerm_postgresql_server.lab01f.name
  start_ip_address    = chomp(data.http.myip.response_body)
  end_ip_address      = chomp(data.http.myip.response_body)
}

resource "azurerm_postgresql_firewall_rule" "lab01f02" {
  name                = "Azure"
  resource_group_name = azurerm_resource_group.dp300.name
  server_name         = azurerm_postgresql_server.lab01f.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
