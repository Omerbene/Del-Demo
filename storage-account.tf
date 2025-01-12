# Create a storage account
resource "azurerm_storage_account" "demo_sa" {
  name                     = "omerdemodel"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [azurerm_resource_group.rg]

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      customer_managed_key
    ]
  }
}

# Create a Blob Container
resource "azurerm_storage_container" "demo_container" {
  name                  = "demo"
  storage_account_name  = azurerm_storage_account.demo_sa.name
  container_access_type = "private"
}

# Configure Storage account to use CMK
resource "azurerm_storage_account_customer_managed_key" "example" {
  storage_account_id = azurerm_storage_account.demo_sa.id
  key_vault_id       = azurerm_key_vault.KeyVault.id
  key_name           = azurerm_key_vault_key.generated.name
}