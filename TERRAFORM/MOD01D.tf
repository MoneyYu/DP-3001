## MOD-01-D-SQL-DATABASE-ELASTIC-POOL
resource "azurerm_mssql_elasticpool" "lab01d" {
  name                = "${local.lab01d_name}-elasticpool-${local.random_str}"
  resource_group_name = azurerm_resource_group.dp300.name
  location            = azurerm_resource_group.dp300.location
  server_name         = azurerm_mssql_server.lab01.name
  max_size_gb         = 100

  sku {
    name     = "StandardPool"
    tier     = "Standard"
    capacity = 100
  }

  per_database_settings {
    min_capacity = 0
    max_capacity = 100
  }

  tags = {
    environment = local.group_name
  }
}

resource "azurerm_mssql_database" "lab01d01" {
  name            = "${local.lab01d_name}-elastic01-db-${local.random_str}"
  server_id       = azurerm_mssql_server.lab01.id
  sku_name        = "ElasticPool"
  elastic_pool_id = azurerm_mssql_elasticpool.lab01d.id

  tags = {
    environment = local.group_name
  }
}

resource "azurerm_mssql_database" "lab01d02" {
  name            = "${local.lab01d_name}-elastic02-db-${local.random_str}"
  server_id       = azurerm_mssql_server.lab01.id
  sku_name        = "ElasticPool"
  elastic_pool_id = azurerm_mssql_elasticpool.lab01d.id

  tags = {
    environment = local.group_name
  }
}

resource "azurerm_mssql_database_extended_auditing_policy" "lab01d01" {
  database_id                             = azurerm_mssql_database.lab01d01.id
  storage_endpoint                        = azurerm_storage_account.lab01.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.lab01.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 6
}

resource "azurerm_mssql_database_extended_auditing_policy" "lab01d02" {
  database_id                             = azurerm_mssql_database.lab01d02.id
  storage_endpoint                        = azurerm_storage_account.lab01.primary_blob_endpoint
  storage_account_access_key              = azurerm_storage_account.lab01.primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 6
}
