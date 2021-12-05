# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
    required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = "=2.46.0"
      }
    }
  }
  
  # Configure the Microsoft Azure Provider
  provider "azurerm" {
    features {}
  }
  
  # Create a resource group
  resource "azurerm_resource_group" "main" {
    name     = "devops-ng-rg"
    location = "West Europe"
  }
  
  resource "azurerm_virtual_network" "main" {
    name                = "${var.prefix}-virtualNetwork1"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    address_space       = ["10.0.0.0/16"]
  }
  
  resource "azurerm_subnet" "main" {
    name                 = "${var.prefix}-subnet"
    resource_group_name  = azurerm_resource_group.main.name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes     = ["10.0.1.0/24"]
  }
  
  resource "azurerm_public_ip" "main" {
    name                    = "${var.prefix}-pip"
    location                = azurerm_resource_group.main.location
    resource_group_name     = azurerm_resource_group.main.name
    allocation_method       = "Static"
  }
  
  resource "azurerm_network_security_group" "main" {
    name                = "acceptanceTestSecurityGroup1"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
  
    security_rule {
      name                       = "SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
  
  resource "azurerm_subnet_network_security_group_association" "main" {
    subnet_id                 = azurerm_subnet.main.id
    network_security_group_id = azurerm_network_security_group.main.id
  }
  
  resource "azurerm_virtual_machine" "main" {
    name                  = "${var.prefix}-vm"
    location              = azurerm_resource_group.main.location
    resource_group_name   = azurerm_resource_group.main.name
    network_interface_ids = [azurerm_network_interface.main.id]
    vm_size               = "Standard_B1ls"  # Standard_DS1_v2"
  
    storage_image_reference {
      publisher = "Canonical"
      offer     = "UbuntuServer"
      sku       = "16.04-LTS"
      version   = "latest"
    }
  
    storage_os_disk {
      name              = "ngosdisk1"
      caching           = "ReadWrite"
      create_option     = "FromImage"
      managed_disk_type = "Standard_LRS"
    }
  
    os_profile {
      computer_name  = "hostname"
      admin_username = "testadmin"
      admin_password = "Password1234!"
    }
  
    os_profile_linux_config {
      disable_password_authentication = false
    }
  }
  
  resource "azurerm_network_interface" "main" {
    name                = "${var.prefix}-nic"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
  
    ip_configuration {
      name                          = "internal"
      subnet_id                     = azurerm_subnet.main.id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.main.id
    }
  }
  
  variable "prefix"{
      default = "devops-ng"
  }