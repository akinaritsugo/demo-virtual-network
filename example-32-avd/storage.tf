resource "azurerm_storage_account" "profiles" {
  name                     = replace("${var.prj}-${var.env}-profile-sa", "-", "")
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  tags = {
    project     = var.prj
    environment = var.env
  }
}

resource "azurerm_storage_share" "profiles" {
  name                 = "profiles"
  storage_account_name = azurerm_storage_account.profiles.name
  quota                = 50
}