output "jenkins_ip_address" {
  value = module.jenkins-vm.instance_ip_addr
  description = "jenkins-vm instance ip address"
}

output "production_ip_adress" {
  value = module.production-vm.instance_ip_addr
  description = "production-vm instance ip address"
}