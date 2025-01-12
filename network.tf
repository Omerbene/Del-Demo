# create a Vnet
resource "azurerm_virtual_network" "Vnet" {
  name                = "Omer-Vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["192.168.0.0/16"]
  depends_on          = [azurerm_resource_group.rg]
}

# Create a subnet inside the Vnet
resource "azurerm_subnet" "demo_subnet" {
  name                 = "Demo-Subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = ["192.168.1.0/24"]
  depends_on           = [azurerm_resource_group.rg]
}

# Assign the NSG to the Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_Associate" {
  subnet_id                 = azurerm_subnet.demo_subnet.id
  network_security_group_id = azurerm_network_security_group.demoSG.id
}
