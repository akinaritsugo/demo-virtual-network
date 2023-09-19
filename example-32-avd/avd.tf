# AVD Workspace
resource "azurerm_virtual_desktop_workspace" "workspace" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  name          = "${var.prj}-${var.env}-workspace"
  friendly_name = "workspace"
  description   = "workspace"
}

# AVD Host Pool
resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  name          = "${var.prj}-${var.env}-hostpool"
  friendly_name = "hostpool"
  description   = "hostpool"

  validate_environment     = true
  start_vm_on_connect      = true
  custom_rdp_properties    = "audiocapturemode:i:1;audiomode:i:0;"
  type                     = "Pooled"
  maximum_sessions_allowed = 10
  load_balancer_type       = "BreadthFirst"
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "registkey" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.hostpool.id
  # expiration は14日間(=336時間)。1時間以上30日以内で指定
  expiration_date = timeadd(timestamp(), "336h")

  lifecycle {
    ignore_changes = [
      expiration_date
    ]
  }
}

# AVD Application Group
resource "azurerm_virtual_desktop_application_group" "desktop" {
  resource_group_name = azurerm_resource_group.rg.name
  host_pool_id        = azurerm_virtual_desktop_host_pool.hostpool.id
  location            = azurerm_resource_group.rg.location
  type                = "Desktop"
  name                = "${var.prj}-${var.env}-desktop-dag"
  friendly_name       = "Desktop Application Group"
  description         = "AVD application group"
  depends_on = [
    azurerm_dev_test_global_vm_shutdown_schedule.adds
  ]
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "ws-desktop-dag" {
  application_group_id = azurerm_virtual_desktop_application_group.desktop.id
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
}