terraform {
  required_version = ">= 1.0"
  
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.18.0"
    }
  }
}

provider "vault" {
  address      = var.vault_address
  token        = var.vault_token
  ca_cert_file = var.vault_ca_cert_file
}
