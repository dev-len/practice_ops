# outputs.tf

output "master_node_public_ip" {
  description = "마스터 노드의 공인 IP 주소"
  value       = azurerm_public_ip.master_pip.ip_address
}

output "cpu_worker_node_public_ips" {
  description = "CPU 워커 노드들의 공인 IP 주소 리스트"
  value       = [for pip in azurerm_public_ip.worker_pip : pip.ip_address]
}

output "gpu_worker_node_public_ip" {
  description = "GPU 워커 노드의 공인 IP 주소"
  value       = azurerm_public_ip.gpu_worker_pip.ip_address
}

output "ssh_command_master" {
  description = "마스터 노드 SSH 접속 명령어"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.master_pip.ip_address}"
}