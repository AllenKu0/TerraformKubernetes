1. [linux 下載](https://spacelift.io/blog/how-to-install-terraform)
```
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update
sudo apt-get install terraform

terraform --version
```
2. [init.tf](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
```
<!-- kubernetes 的 provider -->
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  <!--  config 不給連不到  -->
  config_path    = "~/.kube/config"
  config_context = "kubernetes-admin@kubernetes"
  host       = "https://192.168.1.194:6443"
  # Configure authentication (token, service account, etc.) based on your cluster setup
}
```
3. terraform init
到init.tf資料夾執行`terraform init`
![image](https://hackmd.io/_uploads/By7FCG_nA.png)

4. 新建 secret.tf
```
<!-- 暴力測試 -->
resource "kubernetes_secret" "my_secret" {
  metadata {
    name      = "my-secret"
    namespace = "default"
  }
  data = {
    username = base64encode("my-username")
    password = base64encode("my-password")
  }
}

<!-- VAR 傳入-->
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
```
5. plan and apply
```
<!-- 可以先驗證修改 -->
terraform plan
<!-- 執行修改，也會有確認，輸入yes後apply -->
terraform apply
```
6. 驗證
```
<!-- secret 確認 -->
kubectl get secret my-secret -o yaml
<!--  decode 驗證 -->
echo 'encoded_value' | base64 --decode
```