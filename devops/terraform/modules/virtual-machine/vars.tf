variable "rg" {
  description = "Contains information for the resource group that the vm will be added"
  type = map(string)
}

variable "subnet" {
  description = "Contains information for the subnet that the vm will be added"
  type = map(string)
}

variable "prefix" {
  description = "The prefix that will be given to the specific vm and its associated resources"
  type = string
}

variable "postfix" {
  description = "The postfix that will be given to the specific vm and its associated resources"
  type = string
}

variable "disk_name" {
  description = "The name of the disk that will be used for the vm"
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "public_key" {
  type = string
}