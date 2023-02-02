data "external" "minikube" {
  program = ["bash", "-c", "${path.module}/minikube-ip.sh"]
}

resource "helm_release" "wordpress" {
  name             = var.application
  namespace        = var.wordpress_namespace
  create_namespace = true
  chart            = "${path.module}/${var.application}"
  timeout          = 120

  set {
    name  = "ingress.ip"
    value = data.external.minikube.result.my_ip
  }

  set {
    name  = "db.host"
    value = "${var.mysql_release}.${var.mysql_release}.svc.cluster.local"
  }

  set {
    name  = "db.name"
    value = var.mysql_database
  }

  set {
    name  = "db.user"
    value = var.mysql_user
  }

  set {
    name  = "db.password"
    value = var.mysql_password
  }
  depends_on = [
    helm_release.cert-manager,
    helm_release.mysql,
  ]
}

resource "helm_release" "cert-manager" {
  name             = var.certmanager_release
  namespace        = var.certmanager_release
  create_namespace = true
  repository       = var.helm_repo
  chart            = var.certmanager_release
  timeout          = 120
  set {
    name  = "installCRDs"
    value = "true"
  }
}
resource "helm_release" "mysql" {
  name             = var.mysql_release
  create_namespace = true
  namespace        = var.mysql_release
  repository       = var.helm_repo
  chart            = var.mysql_release
  timeout          = 120
  
  set {
    name  = "auth.database"
    value = var.mysql_database
  }
  set {
    name  = "auth.username"
    value = var.mysql_user
  }
  set {
    name  = "auth.password"
    value = var.mysql_password
  }
}
