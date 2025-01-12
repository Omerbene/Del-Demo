# Create Key Vault
resource "azurerm_key_vault" "KeyVault" {
  name                        = "Omerd-Demo-KV"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled    = true
  sku_name                    = "standard"
  enable_rbac_authorization   = true
  #depends_on = [azurerm_resource_group.rg]
}

# Assign Key Vault Administrator Role to the Current User
resource "azurerm_role_assignment" "current_user" {
  scope                = azurerm_key_vault.KeyVault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Assign Key Vault Crypto User Role to the Storage Account
resource "azurerm_role_assignment" "storage_account" {
  scope                = azurerm_key_vault.KeyVault.id
  role_definition_name = "Key Vault Crypto User" # Minimum role required for encryption
  principal_id         = azurerm_storage_account.demo_sa.identity[0].principal_id
}

# Create a Secret
resource "azurerm_key_vault_secret" "demo_secret" {
  name         = "Demo-VM-Secret"
  value        = random_password.omervm.result
  key_vault_id = azurerm_key_vault.KeyVault.id
  depends_on   = [azurerm_key_vault.KeyVault, azurerm_role_assignment.current_user]

}

# Generate random password for the VM
resource "random_password" "omervm" {
  length  = 12
  special = true

}

# Output the Key Vault Secret Name
output "vm_password_secret" {
  value     = azurerm_key_vault_secret.demo_secret.name
  sensitive = true
}



