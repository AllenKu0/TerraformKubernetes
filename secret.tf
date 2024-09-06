variable "username" {
  sensitive = true
}

variable "password" {
  sensitive = true
}

resource "kubernetes_secret" "my_secret" {
  metadata {
    name      = "my-secret"
    namespace = "default"
  }
  data = {
    username = base64encode(var.username)
    password = base64encode(var.password)
  }
}