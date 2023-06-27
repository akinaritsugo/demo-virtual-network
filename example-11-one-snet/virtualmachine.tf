resource "azurerm_windows_virtual_machine" "win2019" {
  count               = var.servercount
  name                = "${var.prj}-${var.env}-${var.servername}-vm-${format("%02d", count.index + 1)}"
  computer_name       = var.servername
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s"      // Standard_B2ms, Standard_B4ms
  admin_username      = var.username
  admin_password      = var.password

  os_disk {
    name                 = "${var.prj}-${var.env}-${var.servername}-vm-${format("%02d", count.index + 1)}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  network_interface_ids = [
    element(azurerm_network_interface.win2019.*.id, count.index),
  ]
}

# NIC設定
resource "azurerm_network_interface" "win2019" {
  count               = var.servercount
  name                = "${var.prj}-${var.env}-${var.servername}-vm-${format("%02d", count.index + 1)}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.win2019.*.id, count.index)
  }
}

# Public IP
resource "azurerm_public_ip" "win2019" {
  count               = var.servercount
  name                = "${var.prj}-${var.env}-${var.servername}-vm-${format("%02d", count.index + 1)}-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"

  tags = {
    project     = var.prj
    environment = var.env
  }
}

# 自動シャットダウン設定
resource "azurerm_dev_test_global_vm_shutdown_schedule" "win2019" {
  count                 = var.servercount
  virtual_machine_id    = element(azurerm_windows_virtual_machine.win2019.*.id, count.index)
  location              = azurerm_resource_group.rg.location
  enabled               = true
  daily_recurrence_time = "0400"
  timezone              = "Tokyo Standard Time"
  notification_settings {
    enabled = false
  }
}