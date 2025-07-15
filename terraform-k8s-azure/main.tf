terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# 사용할 Azure 프로바이더 설정
provider "azurerm" {
  features {}
}

# 모든 리소스를 담을 리소스 그룹 생성
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}