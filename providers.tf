
# Configuring terraform kubernetes provider with minikube context and pointing to local kube config

provider "kubernetes" {
  config_context_cluster   = "minikube"
  config_path = "~/.kube/config"
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "wordpress-deployment" {
  name       = "wordpress-deployment"
  namespace  = "default"
  #must change to my repo link
  #repository = "https://github.com/Mustafa315/wordpress-deployment"
  chart      = "./wordpress-deployment"

    #values = [
    #file("/home/mustafa/wordpressproject/wordpress-deployment/values.yaml")
  #]

  set {
    name  = "service.type"
    value = "NodePort"
  }

  set {
    name  = "service.nodePorts.http"
    value = "31204"
  }
  
}




# minikube ip
# Visit : <minikube ip>:31204