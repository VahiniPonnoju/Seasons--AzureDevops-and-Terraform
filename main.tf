terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  backend "azurerm" {
    resource_group_name = "tf_rg"
    storage_account_name = "tfblobstorageaccount"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "tf_test" {
  location = "UK South"
  name = "tf_rg"
}
resource "random_id" "suffix" {
  byte_length = 4
}
variable "imagebuild" {
  type        = string
  }
resource "azurerm_container_group" "tfcg_test" {
  name                = "weatherapi"
  location            = azurerm_resource_group.tf_test.location
  resource_group_name = azurerm_resource_group.tf_test.name

  ip_address_type = "Public"
  dns_name_label  = "weatherapi-${random_id.suffix.hex}"
  os_type         = "Linux"

  container {
    name   = "weatherapi"
    image  = "vahiniponnoju/weatherapi:${var.imagebuild}"

    cpu    = 1
    memory = 1.5

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}