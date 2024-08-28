## MOD-01
resource "azurerm_mssql_server" "lab01" {
  name                         = "${local.lab01_name}-azure-sql-${local.random_str}"
  resource_group_name          = azurerm_resource_group.dp300.name
  location                     = azurerm_resource_group.dp300.location
  version                      = "12.0"
  administrator_login          = var.user_name
  administrator_login_password = var.user_passowrd

  azuread_administrator {
    login_username = "Money Yu"
    object_id      = local.admin_oid
  }

  tags = {
    environment = local.group_name
  }
}

resource "azurerm_mssql_firewall_rule" "lab0101" {
  name             = "FirewallRule-Money"
  server_id        = azurerm_mssql_server.lab01.id
  start_ip_address = chomp(data.http.myip.response_body)
  end_ip_address   = chomp(data.http.myip.response_body)
}

resource "azurerm_mssql_firewall_rule" "lab0102" {
  name             = "FirewallRule-Azure"
  server_id        = azurerm_mssql_server.lab01.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_server_extended_auditing_policy" "lab01" {
  server_id                               = azurerm_mssql_server.lab01.id
  storage_endpoint                        = azurerm_storage_account.lab01.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.lab01.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 7
}

resource "azurerm_storage_account" "lab01" {
  name                     = "${local.lab01_name}stor${local.random_str}"
  resource_group_name      = azurerm_resource_group.dp300.name
  location                 = azurerm_resource_group.dp300.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = local.group_name
  }
}
