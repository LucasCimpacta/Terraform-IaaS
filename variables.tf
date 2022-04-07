variable "prefix" {
  description = "This prefix will be included in the name of some resources."
  default     = "apacheimpactalucas"
}

variable "resource_group_name" {
  description = "The name of your Azure Resource Group."
  default     = "Apache-TerraformImpactaLucasmc"
}

variable "location" {
  description = "The region where the virtual network is created."
  default     = "centralus"
}

variable "virtual_network_name" {
  description = "The name for your virtual network."
  default     = "vnet"
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = ["10.0.2.0/24"]
}

variable "hostname" {
  description = "Virtual machine hostname. Used for local hostname, DNS, and storage-related names."
  default     = "vmlc"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_E2bs_v5"
}

variable "image_publisher" {
  description = "Name of the publisher of the image (az vm image list)"
  default     = "Canonical"
}

variable "image_offer" {
  description = "Name of the offer (az vm image list)"
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "Image SKU to apply (az vm image list)"
  default     = "18.04-LTS"
}

variable "image_version" {
  description = "Version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "admin_username" {
  description = "Administrator user name"
  default     = "lucas"
}

variable "admin_password" {
  description = "Administrator password"
  default     = "Admin!@#123"
}

