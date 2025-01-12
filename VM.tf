# 4. Create a Public IP Address
resource "azurerm_public_ip" "demovm" {
  name                = "demo-vm-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

}

# Network Interface
resource "azurerm_network_interface" "demo_nic" {
  name                = "Demo-nic"
  location            = var.location
  resource_group_name = var.resource_group_name


  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.demo_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demovm.id

  }

}

# Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "demo_vm" {
  name                = "Demo-Omer"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  admin_password      = random_password.omervm.result


  network_interface_ids = [
    azurerm_network_interface.demo_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  # Enable System-Assigned Managed Identity
  identity {
    type = "SystemAssigned"
  }
}

#  Assign RBAC Role for Storage Account
resource "azurerm_role_assignment" "storage_blob_role" {
  principal_id         = azurerm_windows_virtual_machine.demo_vm.identity[0].principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.demo_sa.id
}


