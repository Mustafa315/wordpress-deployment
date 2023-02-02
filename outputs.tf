output "application_url" {
  value = "${data.external.minikube.result.my_ip}-app-nip.io"
  description = "URL of the application to be accessed."
}