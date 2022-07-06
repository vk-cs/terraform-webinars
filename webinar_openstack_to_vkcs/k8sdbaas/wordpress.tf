resource "kubernetes_namespace" "wordpress" {
  metadata {
    labels = {
      app = "wordpress"
    }
    name = "wordpress"
  }
}

resource "kubernetes_service" "wordpress_ingress" {
  metadata {
    name = "wordpress"
    namespace = kubernetes_namespace.wordpress.id
    labels = {
      app = "wordpress"
    }
  }
  spec {
    selector = {
      app = "wordpress"
    }
    port {
      port = 80
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_persistent_volume_claim" "wp_pv_claim" {
  metadata {
    name = "wp-pv-claim"
    namespace = kubernetes_namespace.wordpress.id
    labels = {
      "app" = "wordpress"
    }
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "20Gi"
      }
    }
    storage_class_name = "csi-ceph-ssd-ms1"
  }
}

resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wordpress"
    namespace = kubernetes_namespace.wordpress.id
    labels = {
      app = "wordpress"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "wordpress"
        tier = "frontend"
      }
    }

    strategy {
      type = "RollingUpdate"
    }

    template {
      metadata {
        labels = {
          app = "wordpress"
          tier = "frontend"
        }
      }

      spec {
        container {
          image = "wordpress:6.0.0-apache"
          name  = "wordpress"

          resources {
            limits = {
              cpu    = "1"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "128Mi"
            }
          }

          env {
            name = "WORDPRESS_DB_HOST"
            value = join(".",[vkcs_db_instance.db-instance.name,vkcs_networking_network.k8s.private_dns_domain])
          }

          env {
            name = "WORDPRESS_DB_USER"
            value = vkcs_db_user.db-user.name
          }

          env {
            name = "WORDPRESS_DB_PASSWORD"
            value = vkcs_db_user.db-user.password
          }

          port {
            container_port = 80
            name = "wordpress"
          }

          volume_mount {
            name = "wordpress-persistent-storage"
            mount_path = "/var/www/html"
          }

        }
        volume {
          name = "wordpress-persistent-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.wp_pv_claim.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "wordpress_hpa" {
  metadata {
    name = "wordpress-hpa"
    namespace = kubernetes_namespace.wordpress.id
  }

  spec {
    max_replicas = 10
    min_replicas = 2
    target_cpu_utilization_percentage = 50

    scale_target_ref {
      kind = "Deployment"
      name = kubernetes_deployment.wordpress.metadata[0].name
    }
  }
}

output "external_ip" {
  value = kubernetes_service.wordpress_ingress.status[0].load_balancer[0].ingress[0].ip
}
