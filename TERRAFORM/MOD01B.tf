## MOD-01-CB-SQL-MI
resource "azurerm_network_security_group" "lab01b" {
  name                = "${local.lab01b_name}-nsg-${local.random_str}"
  location            = azurerm_resource_group.dp300.location
  resource_group_name = azurerm_resource_group.dp300.name

  tags = {
    environment = local.group_name
  }
}


resource "azurerm_network_security_rule" "allow_management_inbound" {
  name                        = "allow_management_inbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["9000", "9003", "1438", "1440", "1452"]
  source_address_prefix       = chomp(data.http.myip.response_body)
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dp300.name
  network_security_group_name = azurerm_network_security_group.lab01b.name
}

resource "azurerm_network_security_rule" "allow_mssql_inbound" {
  name                        = "allow_mssql_inbound"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["1433", "3342"]
  source_address_prefix       = chomp(data.http.myip.response_body)
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dp300.name
  network_security_group_name = azurerm_network_security_group.lab01b.name
}

resource "azurerm_network_security_rule" "allow_misubnet_inbound" {
  name                        = "allow_misubnet_inbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.2.1.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dp300.name
  network_security_group_name = azurerm_network_security_group.lab01b.name
}

resource "azurerm_network_security_rule" "allow_health_probe_inbound" {
  name                        = "allow_health_probe_inbound"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dp300.name
  network_security_group_name = azurerm_network_security_group.lab01b.name
}

resource "azurerm_network_security_rule" "allow_tds_inbound" {
  name                        = "allow_tds_inbound"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dp300.name
  network_security_group_name = azurerm_network_security_group.lab01b.name
}

resource "azurerm_network_security_rule" "deny_all_inbound" {
  name                        = "deny_all_inbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dp300.name
  network_security_group_name = azurerm_network_security_group.lab01b.name
}

resource "azurerm_network_security_rule" "allow_management_outbound" {
  name                        = "allow_management_outbound"
  priority                    = 102
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443", "12000"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dp300.name
  network_security_group_name = azurerm_network_security_group.lab01b.name
}

resource "azurerm_network_security_rule" "allow_misubnet_outbound" {
  name                        = "allow_misubnet_outbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.2.1.0/24"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dp300.name
  network_security_group_name = azurerm_network_security_group.lab01b.name
}

resource "azurerm_network_security_rule" "deny_all_outbound" {
  name                        = "deny_all_outbound"
  priority                    = 4096
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.dp300.name
  network_security_group_name = azurerm_network_security_group.lab01b.name
}

resource "azurerm_virtual_network" "lab01b" {
  name                = "${local.lab01b_name}-vnet-${local.random_str}"
  resource_group_name = azurerm_resource_group.dp300.name
  address_space       = ["10.2.0.0/16"]
  location            = azurerm_resource_group.dp300.location

  tags = {
    environment = local.group_name
  }
}

resource "azurerm_subnet" "lab01b" {
  name                 = "subnet-mi"
  resource_group_name  = azurerm_resource_group.dp300.name
  virtual_network_name = azurerm_virtual_network.lab01b.name
  address_prefixes     = ["10.2.1.0/24"]

  delegation {
    name = "managedinstancedelegation"

    service_delegation {
      name    = "Microsoft.Sql/managedInstances"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action", "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "lab01b" {
  subnet_id                 = azurerm_subnet.lab01b.id
  network_security_group_id = azurerm_network_security_group.lab01b.id
}

resource "azurerm_route_table" "lab01b" {
  name                          = "${local.lab01b_name}-route-${local.random_str}"
  location                      = azurerm_resource_group.dp300.location
  resource_group_name           = azurerm_resource_group.dp300.name
  disable_bgp_route_propagation = false
  depends_on = [
    azurerm_subnet.lab01b,
  ]

  tags = {
    environment = local.group_name
  }
}

resource "azurerm_subnet_route_table_association" "lab01b" {
  subnet_id      = azurerm_subnet.lab01b.id
  route_table_id = azurerm_route_table.lab01b.id
}

resource "azurerm_mssql_managed_instance" "lab01b" {
  name                = "${local.lab01b_name}-mssql-mi-${local.random_str}"
  resource_group_name = azurerm_resource_group.dp300.name
  location            = azurerm_resource_group.dp300.location

  license_type       = "BasePrice"
  sku_name           = "GP_Gen5"
  storage_size_in_gb = 32
  subnet_id          = azurerm_subnet.lab01b.id
  vcores             = 4
  collation          = "SQL_Latin1_General_CP1_CI_AS"

  administrator_login          = var.user_name
  administrator_login_password = var.user_passowrd

  public_data_endpoint_enabled = true

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_subnet_network_security_group_association.lab01b,
    azurerm_subnet_route_table_association.lab01b,
  ]

  tags = {
    environment = local.group_name
  }
}