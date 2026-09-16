locals {
  common_tags = {
    user        = var.user_id
    Project     = "azure-training"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

data "azurerm_resource_group" "lab" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "lab" {
  name                = "cloudcorp-${var.environment}-vnet"
  address_space       = ["10.20.0.0/16"]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.lab.name
  tags                = local.common_tags
}

resource "azurerm_subnet" "frontend" {
  name                 = "subnet-frontend"
  resource_group_name  = data.azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.20.1.0/24"]
}

resource "azurerm_subnet" "backend" {
  name                 = "subnet-backend"
  resource_group_name  = data.azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = ["10.20.2.0/24"]
}

resource "azurerm_network_security_group" "web" {
  name                = "nsg-web01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.lab.name
  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = local.common_tags
}

resource "azurerm_public_ip" "web" {
  name                = "pip-web01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = local.common_tags
}

resource "azurerm_network_interface" "web" {
  name                = "nic-web01"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.lab.name
  tags                = local.common_tags
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.frontend.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web.id
  }
}

resource "azurerm_network_interface_security_group_association" "web" {
  network_interface_id      = azurerm_network_interface.web.id
  network_security_group_id = azurerm_network_security_group.web.id
}

resource "azurerm_linux_virtual_machine" "web" {
  name                  = "cloudcorp-${var.environment}-web01"
  resource_group_name   = data.azurerm_resource_group.lab.name
  location              = var.location
  size                  = "Standard_B1s"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.web.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
  tags = local.common_tags
}
