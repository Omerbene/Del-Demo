# Generate Keys for encrypt SA
resource "azurerm_key_vault_key" "generated" {
  name         = "demo-cert"
  key_vault_id = azurerm_key_vault.KeyVault.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
  depends_on = [azurerm_role_assignment.current_user]

}