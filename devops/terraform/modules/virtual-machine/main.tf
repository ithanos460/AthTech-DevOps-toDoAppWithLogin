resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-pip-${var.postfix}"
  location            = var.rg.location
  resource_group_name = var.rg.name
  allocation_method   = "Static"
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm-${var.postfix}"
  location              = var.rg.location
  resource_group_name   = var.rg.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_B2s" # Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = var.disk_name
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      key_data = var.public_key
      path = "/home/${var.admin_username}/.ssh/authorized_keys"
    }
  }
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic-${var.postfix}"
  location            = var.rg.location
  resource_group_name = var.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}