variable "location" {
  description = "Location of the VPN resources."
}

variable "environment" {
  description = "Environment."
}

variable "name" {
  description = "Name of the application."
}

variable "vm_size" {
  description = "The SKU which should be used for this Virtual Machine."
}

variable "admin_username" {
  description = "The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created."
}

variable "admin_password" {
  description = "The password of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created."
}