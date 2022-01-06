variable "prefix" {
  type = string
  default = "devops-ng"
}

variable "vm_username" {
  type = string
  sensitive   = true
  description = "Te username of the user to be created"
}

variable "vm_password" {
  type = string
  sensitive = true
  description = "The password for the user to be created"
}
variable "public_key" {
  type = string
}