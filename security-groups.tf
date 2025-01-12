# Network Security Group (NSG)
resource "azurerm_network_security_group" "demoSG" {
  name                = "demo-sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  # Rule to Allow RDP
  security_rule {
    name                       = "Allow-RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "1.1.1.1/32" # Replace with your IP range
    destination_address_prefix = "*"

  }
  depends_on = [azurerm_resource_group.rg]
}