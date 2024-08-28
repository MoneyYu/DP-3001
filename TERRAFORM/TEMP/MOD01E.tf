## MOD-01-E-SQL-DATABASE-HYPERSCALE
resource "azurerm_mssql_database" "lab01e" {
  name         = "${local.lab01e_name}-hyperscale-db-${local.random_str}"
  server_id    = azurerm_mssql_server.lab01.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  sku_name     = "HS_Gen4_1"
  license_type = "BasePrice"

  tags = {
    environment = local.group_name
  }
}

resource "azurerm_mssql_database_extended_auditing_policy" "lab01e" {
  database_id                             = azurerm_mssql_database.lab01e.id
  storage_endpoint                        = azurerm_storage_account.lab01.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.lab01.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 6
}
