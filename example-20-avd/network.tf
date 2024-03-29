resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prj}-${var.env}-main-vnet"
  address_space       = ["172.16.0.0/20"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet configuration
resource "azurerm_subnet" "adds" {
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  name                 = "adds-subnet"
  address_prefixes     = ["172.16.0.0/24"]
}
resource "azurerm_subnet_network_security_group_association" "adds" {
  subnet_id                 = azurerm_subnet.adds.id
  network_security_group_id = azurerm_network_security_group.adds.id
}

# Network Security Group
resource "azurerm_network_security_group" "adds" {
  name                = "${var.prj}-${var.env}-main-adds-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet configuration
resource "azurerm_subnet" "desktop" {
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  name                 = "desktop-subnet"
  address_prefixes     = ["172.16.1.0/24"]
}
resource "azurerm_subnet_network_security_group_association" "desktop" {
  subnet_id                 = azurerm_subnet.desktop.id
  network_security_group_id = azurerm_network_security_group.desktop.id
}

# Network Security Group
resource "azurerm_network_security_group" "desktop" {
  name                = "${var.prj}-${var.env}-main-desktop-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet configuration
resource "azurerm_subnet" "firewall" {
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  name                 = "AzureFirewallSubnet"
  address_prefixes     = ["172.16.2.0/24"]
}
# resource "azurerm_subnet_network_security_group_association" "desktop" {
#   subnet_id                 = azurerm_subnet.desktop.id
#   network_security_group_id = azurerm_network_security_group.desktop.id
# }

# # Network Security Group
# resource "azurerm_network_security_group" "firewall" {
#   name                = "${var.prj}-${var.env}-main-firewall-nsg"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
# }
