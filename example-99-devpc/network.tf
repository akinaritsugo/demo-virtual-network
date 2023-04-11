resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prj}-${var.env}-main-vnet"
  address_space       = ["172.16.0.0/20"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet configuration
resource "azurerm_subnet" "main" {
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  name                 = "main-subnet"
  address_prefixes     = ["172.16.0.0/24"]
}
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# Network Security Group
resource "azurerm_network_security_group" "main" {
  name                = "${var.prj}-${var.env}-main-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
