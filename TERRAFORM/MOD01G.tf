## MOD-01-G-MARIADB
resource "azurerm_mariadb_server" "lab01g" {
  name                = "${local.lab01g_name}-maria-svr-${local.random_str}"
  location            = azurerm_resource_group.dp300.location
  resource_group_name = azurerm_resource_group.dp300.name

  sku_name   = "B_Gen5_1"
  storage_mb = 8192
  version    = "10.3"

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = var.user_name
  administrator_login_password = var.user_passowrd

  public_network_access_enabled    = true
  ssl_enforcement_enabled          = true

  tags = {
    environment = local.group_name
  }
}

resource "azurerm_mariadb_database" "lab01g" {
  name                = "${local.lab01g_name}mariadb${local.random_str}"
  resource_group_name = azurerm_resource_group.dp300.name
  server_name         = azurerm_mariadb_server.lab01g.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_520_ci"
}

resource "azurerm_mariadb_firewall_rule" "lab01g01" {
  name                = "Money"
  resource_group_name = azurerm_resource_group.dp300.name
  server_name         = azurerm_mariadb_server.lab01g.name
  start_ip_address    = chomp(data.http.myip.response_body)
  end_ip_address      = chomp(data.http.myip.response_body)
}

resource "azurerm_mariadb_firewall_rule" "lab01g02" {
  name                = "Azure"
  resource_group_name = azurerm_resource_group.dp300.name
  server_name         = azurerm_mariadb_server.lab01g.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
