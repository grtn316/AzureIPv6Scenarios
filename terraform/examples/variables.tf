variable "resourceGroupName" {
  description = "Name of Resource Group holding Grid Test VM."
  default     = "GridPerfTestRg"
}

variable "location" {
  description = "Azure Region for deployment."
  default     = "eastus2"
}

variable "linuxComputeCount" {
  description = "Number of Linux VMs to deploy."
  default     = 1
}

variable "windowsComputeCount" {
  description = "Number of Windows VMs to deploy."
  default     = 1
}

variable "serverName" {
  description = "VM Name"
  default     = "TestVM"
}

variable "vmSKU" {
  description = "Sku of the Virtual Machines to provision."
  default     = "Standard_D4ds_v4" #Standard_E16ds_v4
}

variable "adminUsername" {
  description = "Username"
  default     = "adminuser"
}

variable "adminPassword" {
  description = "Password"
  default     = ""
}

variable "subnetId" {
  description = "Id of the subnet to attach VM to."
  default     = "" #/subscriptions/<subId>/resourceGroups/<rgName>/providers/Microsoft.Network/virtualNetworks/<vnetName>/subnets/<subnetName>
}

variable "vnetName" {
  description = "Name of the new VNet"
  default     = "TestVNet"
}

variable "addressSpaceIPv4" {
  description = "IPv4 Address Space"
  default     = "10.200.0.0/16"
}

variable "addressSpaceIPv6" {
  description = "IPv6 Address Space"
  default     = "ace:dec:beef::/48"
}

variable "defaultSubnetPrefixIPv4" {
  description = "IP Space for default Subnet"
  default     = "10.200.0.0/20"
}

variable "defaultSubnetPrefixIPv6" {
  description = "IP Space for default Subnet"
  default     = "ace:dec:beef::/64"
}
