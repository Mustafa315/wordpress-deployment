variable "application" {
  default     = "wordpress"
  type        = string
  description = "Name of the wordpress application."
}

variable "mysql_release" {
  default     = "mysql"
  type        = string
  description = "Name of mysql helm chart release."
}

variable "wordpress_namespace" {
  default     = "wordpress"
  type        = string
  description = "Namespace in which wordpress will be installed."
}

variable "certmanager_release" {
  default     = "cert-manager"
  type        = string
  description = "Name of cert-manager helm chart release."
}

variable "helm_repo" {
  default     = "https://charts.bitnami.com/bitnami"
  type        = string
  description = "Repo URL from which, mysql and cert-manager will be installed."
}

variable "mysql_database" {
  default     = "application"
  type        = string
  sensitive   = true
  description = "MySQL database to use with the wordpress application."
}

variable "mysql_user" {
  default     = "user"
  type        = string
  sensitive   = true
  description = "MySQL user that will be the owner of the application database."
}

variable "mysql_password" {
  default     = "dbpassword"
  type        = string
  sensitive   = true
  description = "Password of MySQL user that will be the owner of the application database."
}