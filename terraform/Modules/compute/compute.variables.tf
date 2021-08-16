
variable "resourceGroupName" {
  default = ""
}
variable "computeCount" {
  default = 0 #set to null so coalesce works correctly.
}
variable "serverName" {
  default = "serverName"
}
variable "location" {
  default = "eastus2"
}
variable "zone" {
  default = "2"
}
variable "vmSKU" {
}
variable "osPublisher" {
  default = "Canonical"
}
variable "osOffer" {
  default = "UbuntuServer"
}
variable "osSKU" {
  default = "18.04-LTS"
}
variable "osVersion" {
  default = "latest"
}
variable "storageAccountType" {
  default = "Premium_LRS"
}
variable "adminUsername" {
  default = "adminuser"
}
variable "adminPassword" {
  default = ""
}
variable "enableAcceleratedNetworking" {
  default = true
}
variable "subnetId" {
  default = ""
}
