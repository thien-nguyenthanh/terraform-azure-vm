locals {
  common_tags = {
    Terraform = "true"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "datafrog" {
  name     = "${var.location}-rg-${var.environment}-${var.name}"
  location = var.location
}

resource "azurerm_virtual_network" "datafrog" {
  name                = "${var.location}-vnet-${var.environment}-${var.name}"
  address_space       = ["192.168.0.0/23"]
  location            = azurerm_resource_group.datafrog.location
  resource_group_name = azurerm_resource_group.datafrog.name
}

resource "azurerm_subnet" "datafrog" {
  name                 = "${var.location}-snet-${var.environment}-${var.name}"
  resource_group_name  = azurerm_resource_group.datafrog.name
  virtual_network_name = azurerm_virtual_network.datafrog.name
  address_prefixes     = ["192.168.0.0/26"]
}

resource "azurerm_network_interface" "datafrog" {
  name                = "${var.location}-int-${var.environment}-${var.name}"
  location            = azurerm_resource_group.datafrog.location
  resource_group_name = azurerm_resource_group.datafrog.name

  ip_configuration {
    name                          = "${var.location}-ipc-${var.environment}-${var.name}"
    subnet_id                     = azurerm_subnet.datafrog.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "datafrog" {
  location            = azurerm_resource_group.datafrog.location
  name                = "${var.location}-nsg-${var.environment}-${var.name}"
  resource_group_name = azurerm_resource_group.datafrog.name
  security_rule {
    name                        = "AllowRDP"
    description                 = "Allow connection on RDP protocol access."
    priority                    = 1000
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                   = "Tcp"
    source_port_range           = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    destination_port_ranges     = [
      "3389"
    ]
  }
}

resource "azurerm_windows_virtual_machine" "datafrog" {
  # Issue: "computer_name" can be at most 15 characters
  name                = "vmw-${var.environment}-${var.name}"
  resource_group_name = azurerm_resource_group.datafrog.name
  location            = azurerm_resource_group.datafrog.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  tags                = merge(local.common_tags)
  network_interface_ids = [
    azurerm_network_interface.datafrog.id,
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
}

# Associate the network interface to security group
resource "azurerm_network_interface_security_group_association" "vpn" {
  network_interface_id      = azurerm_network_interface.datafrog.id
  network_security_group_id = azurerm_network_security_group.datafrog.id
}
