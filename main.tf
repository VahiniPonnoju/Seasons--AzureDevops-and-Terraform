terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
terraform {
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
  location = "UKsouth"
  name = "tf_rg"
}
resource "azurerm_container_group" "tfcg_test" {
  name                = "weatherapi"
  location            = azurerm_resource_group.tf_test.location
  resource_group_name = azurerm_resource_group.tf_test.name

  ip_address_type = "Public"
  dns_name_label  = "binarythistlewa"
  os_type         = "Linux"

  container {
    name   = "weatherapi"
    image  = "nginx:latest"

    cpu    = 1
    memory = 1.5

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}