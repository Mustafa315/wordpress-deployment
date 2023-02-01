terraform {

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.0.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.5.1"
    }

  }

  required_version = ">= 1.1.2"
}
