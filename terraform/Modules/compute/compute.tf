#Create Linux VM
resource "azurerm_linux_virtual_machine" "vm" {
  count                           = (length(regexall("Microsoft", var.osPublisher)) > 0 ? 0 : var.computeCount)
  name                            = "${var.serverName}-${count.index + 1}"
  resource_group_name             = var.resourceGroupName
  location                        = var.location
  zone                            = var.zone
  size                            = var.vmSKU
  admin_username                  = var.adminUsername
  admin_password                  = var.adminPassword
  disable_password_authentication = false
  network_interface_ids           = [element(concat(azurerm_network_interface.vm_private_nic.*.id), count.index + 1)]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storageAccountType
  }

  source_image_reference {
    publisher = var.osPublisher
    offer     = var.osOffer
    sku       = var.osSKU
    version   = var.osVersion
  }

}

#Create Windows VM
resource "azurerm_windows_virtual_machine" "vm" {
  count               = (length(regexall("Microsoft", var.osPublisher)) > 0 ? var.computeCount : 0)
  name                = "${var.serverName}-${count.index + 1}"
  resource_group_name = var.resourceGroupName
  location            = var.location
  zone                = var.zone
  size                = var.vmSKU
  admin_username      = var.adminUsername
  admin_password      = var.adminPassword
  #disable_password_authentication = false
  network_interface_ids = [element(concat(azurerm_network_interface.vm_private_nic.*.id), count.index + 1)]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storageAccountType
  }

  source_image_reference {
    publisher = var.osPublisher
    offer     = var.osOffer
    sku       = var.osSKU
    version   = var.osVersion
  }

}

#Create Private NIC for VMs
#IPv4
resource "azurerm_network_interface" "vm_private_nic" {
  count                         = var.computeCount
  name                          = "${var.serverName}-${count.index + 1}-private-nic"
  resource_group_name           = var.resourceGroupName
  location                      = var.location
  enable_accelerated_networking = var.enableAcceleratedNetworking

  ip_configuration { #IPv4 Interface
    name                          = "internal_ipv4"
    subnet_id                     = var.subnetId
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.vm_public_ipv4.*.id, count.index + 1)
    private_ip_address_version    = "IPv4"
    primary                       = true
  }

  ip_configuration { #IPv6 Interface
    name                          = "internal_ipv6"
    subnet_id                     = var.subnetId
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.vm_public_ipv6.*.id, count.index + 1)
    private_ip_address_version    = "IPv6"
  }
}

#Create Public IP for VMs
#IPv4
resource "azurerm_public_ip" "vm_public_ipv4" {
  count               = var.computeCount
  name                = "${var.serverName}-${count.index + 1}-public-ipv4"
  resource_group_name = var.resourceGroupName
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  availability_zone   = var.zone
  ip_version          = "IPv4"

}

#IPv6
resource "azurerm_public_ip" "vm_public_ipv6" {
  count               = var.computeCount
  name                = "${var.serverName}-${count.index + 1}-public-ipv6"
  resource_group_name = var.resourceGroupName
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
  availability_zone   = var.zone
  ip_version          = "IPv6"

}
