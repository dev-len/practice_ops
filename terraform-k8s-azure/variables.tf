# variables.tf

variable "resource_group_name" {
  description = "리소스 그룹의 이름"
  type        = string
  default     = "k8s-dev-rg"
}

variable "location" {
  description = "인프라를 배포할 Azure 지역"
  type        = string
  default     = "Korea Central" # 한국 중부
}

variable "cluster_name" {
  description = "클러스터 이름 (리소스 태그에 사용)"
  type        = string
  default     = "dev-cluster"
}

variable "admin_username" {
  description = "VM에 생성할 관리자 계정 이름"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "VM에 등록할 SSH 공개 키 파일 경로"
  type        = string
  default     = "~/.ssh/id_rsa.pub" # 이 경로에 공개키가 있어야 합니다.
}

variable "master_vm_size" {
  description = "마스터 노드의 VM 사이즈"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "worker_vm_size" {
  description = "CPU 워커 노드의 VM 사이즈"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "gpu_worker_vm_size" {
  description = "GPU 워커 노드의 VM 사이즈 (NVIDIA T4)"
  type        = string
  default     = "Standard_NC4as_T4_v3"
}