resource "azurerm_windows_virtual_machine" "win10ent" {
  name                = "${var.prj}-${var.env}-${var.servername}-vm"
  computer_name       = "${var.servername}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D8s_v3"
  admin_username      = var.username
  admin_password      = var.password

  os_disk {
    name                 = "${var.prj}-${var.env}-${var.servername}-vm-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "win10-22h2-ent-g2"
    version   = "latest"
  }

  network_interface_ids = [
    azurerm_network_interface.win10ent.id,
  ]
}

# NIC設定
resource "azurerm_network_interface" "win10ent" {
  name                = "${var.prj}-${var.env}-${var.servername}-vm-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.win10ent.id
  }
}

# Public IP
resource "azurerm_public_ip" "win10ent" {
  name                = "${var.prj}-${var.env}-${var.servername}-vm-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"

  tags = {
    project     = var.prj
    environment = var.env
  }
}

# 自動シャットダウン設定
resource "azurerm_dev_test_global_vm_shutdown_schedule" "win10ent" {
  virtual_machine_id    = azurerm_windows_virtual_machine.win10ent.id
  location              = azurerm_resource_group.rg.location
  enabled               = true
  daily_recurrence_time = "0400"
  timezone              = "Tokyo Standard Time"
  notification_settings {
    enabled = false
  }
}