provider "kubernetes" {
  config_context_cluster = "minikube"
  config_path            = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
