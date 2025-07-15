# 공통 설정
locals {
  # 사용할 OS 이미지 정보 (Ubuntu 22.04 LTS)
  os_image = {
    publisher = "Canonical"
    offer     = "002-team-LEN"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  ssh_public_key = file(var.ssh_public_key_path)
}

# --- Master Node ---
resource "azurerm_public_ip" "master_pip" {
  name                = "${var.cluster_name}-master-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "master_nic" {
  name                = "${var.cluster_name}-master-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.master_pip.id
  }
}

resource "azurerm_linux_virtual_machine" "master" {
  name                  = "${var.cluster_name}-master"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = var.master_vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.master_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_SSD_LRS"
  }

  source_image_reference {
    publisher = local.os_image.publisher
    offer     = local.os_image.offer
    sku       = local.os_image.sku
    version   = local.os_image.version
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = local.ssh_public_key
  }
}

# --- Worker Nodes (CPU) ---
resource "azurerm_linux_virtual_machine" "worker" {
  count                 = 2 # CPU 워커 노드 2개 생성
  name                  = "${var.cluster_name}-worker-${count.index}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = var.worker_vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.worker_nic[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_SSD_LRS"
  }

  source_image_reference {
    publisher = local.os_image.publisher
    offer     = local.os_image.offer
    sku       = local.os_image.sku
    version   = local.os_image.version
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = local.ssh_public_key
  }
}

resource "azurerm_public_ip" "worker_pip" {
  count               = 2
  name                = "${var.cluster_name}-worker-${count.index}-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "worker_nic" {
  count               = 2
  name                = "${var.cluster_name}-worker-${count.index}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.worker_pip[count.index].id
  }
}

# --- Worker Node (GPU) ---
resource "azurerm_linux_virtual_machine" "gpu_worker" {
  name                  = "${var.cluster_name}-gpu-worker"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = var.gpu_worker_vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.gpu_worker_nic.id]
  
  tags = {
    gpu = "true" # 나중에 쿠버네티스에서 이 노드를 식별하기 위한 태그
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_SSD_LRS"
  }

  source_image_reference {
    publisher = local.os_image.publisher
    offer     = local.os_image.offer
    sku       = local.os_image.sku
    version   = local.os_image.version
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = local.ssh_public_key
  }
}

resource "azurerm_public_ip" "gpu_worker_pip" {
  name                = "${var.cluster_name}-gpu-worker-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "gpu_worker_nic" {
  name                = "${var.cluster_name}-gpu-worker-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.gpu_worker_pip.id
  }
}