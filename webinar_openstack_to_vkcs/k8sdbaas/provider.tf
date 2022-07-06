terraform {
  required_providers {
    vkcs = {
      source = "vk-cs/vkcs"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
  }
}

provider "vkcs" {
    username = var.username

    password = var.password

    project_id = var.project_id
    
    region = var.region
}

provider "kubernetes" {
    host = yamldecode(data.vkcs_kubernetes_cluster.k8s-cluster.k8s_config).clusters.0.cluster.server

    client_certificate     = base64decode(yamldecode(data.vkcs_kubernetes_cluster.k8s-cluster.k8s_config).users.0.user.client-certificate-data)
    client_key             = base64decode(yamldecode(data.vkcs_kubernetes_cluster.k8s-cluster.k8s_config).users.0.user.client-key-data)
    cluster_ca_certificate = base64decode(yamldecode(data.vkcs_kubernetes_cluster.k8s-cluster.k8s_config).clusters.0.cluster.certificate-authority-data)
}
