output "production_ip_address" {
  value = module.production-vm.instance_ip_addr
  description = "production-vm instance ip address"
}