provider "azurerm" {
  features {}
}

resource "azurerm_virtual_network" "vnet" {
  name                = "slcdf-sap-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "Southeast Asia"
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = "slcdf-sap-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]

  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_security_group" "nsg" {
  name                = "slcdf-sap-nsg"
  location            = "Southeast Asia"
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allowRDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allowSSH"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "publicip" {
  name                = "slcdf-sap-publicip"
  location            = "Southeast Asia"
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  domain_name_label   = "slcdf-sap-server-vm"
}

resource "azurerm_network_interface" "nic" {
  name                = "slcdf-sap-vm-nic"
  location            = "Southeast Asia"
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = "slcdf-sap-vm"
  location            = "Southeast Asia"
  resource_group_name = var.resource_group_name
  size                = "Standard_D4s_v4"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.windowsVersion
    version   = "latest"
  }
}
