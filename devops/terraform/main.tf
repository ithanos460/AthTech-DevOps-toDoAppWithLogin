# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  cloud {
    organization = "athtech-devops-todo-with-login"

    workspaces {
      name = "production"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
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

module "jenkins-vm" {
  source = "./modules/virtual-machine"
  
  prefix = var.prefix
  rg = {
    "name": azurerm_resource_group.main.name,
    "location": azurerm_resource_group.main.location
  }
  subnet = {
    "name": azurerm_subnet.main.name,
    "id": azurerm_subnet.main.id
  }
  postfix = "jenkins"
  admin_username = var.vm_username
  admin_password = var.vm_password
}


module "production-vm" {
  source = "./modules/virtual-machine"
  
  prefix = var.prefix
  rg = {
    "name": azurerm_resource_group.main.name,
    "location": azurerm_resource_group.main.location
  }
  subnet = {
    "name": azurerm_subnet.main.name,
    "id": azurerm_subnet.main.id
  }
  postfix = "production"
  admin_username = var.vm_username
  admin_password = var.vm_password
}
