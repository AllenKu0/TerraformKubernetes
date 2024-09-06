terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kubernetes-admin@kubernetes"
  host       = "https://192.168.1.194:6443"
  # Configure authentication (token, service account, etc.) based on your cluster setup
}