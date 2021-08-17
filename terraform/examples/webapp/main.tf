#NOTE: Create .tfvars file. Set password and optional subnetId in *.tfvars file

#Create Linux Webserver
module "createLinuxVM" {
  source = "../../Modules//compute/"

  resourceGroupName           = azurerm_resource_group.rg.name
  computeCount                = 1
  serverName                  = "${var.serverName}-Lnx"
  location                    = azurerm_resource_group.rg.location
  zone                        = 2
  vmSKU                       = var.vmSKU
  osPublisher                 = "Canonical"
  osOffer                     = "UbuntuServer"
  osSKU                       = "18.04-LTS"
  osVersion                   = "latest"
  storageAccountType          = "Premium_LRS"
  adminUsername               = var.adminUsername
  adminPassword               = var.adminPassword
  enableAcceleratedNetworking = true
  subnetId                    = (length(regexall("virtualNetworks", var.subnetId)) > 0 ? var.subnetId : element(azurerm_subnet.subnet.*.id, 1)) #Skip if existing vnet

}

#Create Windows Webserver
module "createWindowsVM" {
  source = "../../Modules//compute/"

  resourceGroupName           = azurerm_resource_group.rg.name
  computeCount                = 1
  serverName                  = "${var.serverName}-Win"
  location                    = azurerm_resource_group.rg.location
  zone                        = 2
  vmSKU                       = var.vmSKU
  osPublisher                 = "MicrosoftWindowsServer"
  osOffer                     = "WindowsServer"
  osSKU                       = "2019-Datacenter"
  osVersion                   = "latest"
  storageAccountType          = "Premium_LRS"
  adminUsername               = var.adminUsername
  adminPassword               = var.adminPassword
  enableAcceleratedNetworking = true
  subnetId                    = (length(regexall("virtualNetworks", var.subnetId)) > 0 ? var.subnetId : element(azurerm_subnet.subnet.*.id, 1)) #Skip if existing vnet

}

#Create Database Server
module "createWindowsDatabaseVM" {
  source = "../../Modules//compute/"

  resourceGroupName           = azurerm_resource_group.rg.name
  computeCount                = 1
  serverName                  = "${var.serverName}-DB"
  location                    = azurerm_resource_group.rg.location
  zone                        = 2
  vmSKU                       = "Standard_E16ds_v4"
  osPublisher                 = "MicrosoftWindowsServer"
  osOffer                     = "WindowsServer"
  osSKU                       = "2019-Datacenter"
  osVersion                   = "latest"
  storageAccountType          = "Premium_LRS"
  adminUsername               = var.adminUsername
  adminPassword               = var.adminPassword
  enableAcceleratedNetworking = true
  subnetId                    = (length(regexall("virtualNetworks", var.subnetId)) > 0 ? var.subnetId : element(azurerm_subnet.subnet.*.id, 1)) #Skip if existing vnet

}

#Create Windows Desktop
module "createWindowsDesktopVM" {
  source = "../../Modules//compute/"

  resourceGroupName           = azurerm_resource_group.rg.name
  computeCount                = 1
  serverName                  = "${var.serverName}-WS"
  location                    = azurerm_resource_group.rg.location
  zone                        = 2
  vmSKU                       = var.vmSKU
  osPublisher                 = "MicrosoftWindowsDesktop"
  osOffer                     = "Windows-10"
  osSKU                       = "20h2-pro"
  osVersion                   = "latest"
  storageAccountType          = "Premium_LRS"
  adminUsername               = var.adminUsername
  adminPassword               = var.adminPassword
  enableAcceleratedNetworking = true
  subnetId                    = (length(regexall("virtualNetworks", var.subnetId)) > 0 ? var.subnetId : element(azurerm_subnet.subnet.*.id, 1)) #Skip if existing vnet

}


#Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resourceGroupName
  location = var.location
}

#Create VNET
resource "azurerm_virtual_network" "vnet" {
  count               = (length(regexall("virtualNetworks", var.subnetId)) > 0 ? 0 : 1) #Skip if existing vnet
  name                = var.vnetName
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = [var.addressSpaceIPv4, var.addressSpaceIPv6]



}

#Create Dual Stacked Subnet
resource "azurerm_subnet" "subnet" {
  count                = (length(regexall("virtualNetworks", var.subnetId)) > 0 ? 0 : 1) #Skip if existing vnet
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = element(azurerm_virtual_network.vnet.*.name, 1) #get first vnet name
  address_prefixes     = [var.defaultSubnetPrefixIPv4, var.defaultSubnetPrefixIPv6]

  depends_on = [azurerm_virtual_network.vnet]
}

#Create NSG for Subnet
resource "azurerm_network_security_group" "subnetNSG" {
  count               = (length(regexall("virtualNetworks", var.subnetId)) > 0 ? 0 : 1) #Skip if existing vnet
  name                = "${var.serverName}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "107.216.0.0/16"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "RDP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "107.216.0.0/16"
    destination_address_prefix = "*"
  }
}

#Associate NSG to Subnet
resource "azurerm_subnet_network_security_group_association" "subnet" {
  #count                     = (contains(["virtualNetworks"], var.subnetId) ? 0 : 1)     #Skip if existing vnet
  count                     = (length(regexall("virtualNetworks", var.subnetId)) > 0 ? 0 : 1) #Skip if existing vnet
  subnet_id                 = element(azurerm_subnet.subnet.*.id, 1)                          #get default subnet id 
  network_security_group_id = element(azurerm_network_security_group.subnetNSG.*.id, 1)       #get nsg id 
}
