data "vkcs_kubernetes_clustertemplate" "cluster_template"{
    version = var.k8s-version
}

data "vkcs_compute_flavor" "k8s_master" {
    name = var.k8s_master-flavor
}

data "vkcs_compute_flavor" "k8s_worker" {
    name = var.k8s_worker-flavor
}

resource "vkcs_kubernetes_cluster" "k8s-cluster" {
    depends_on = [
        vkcs_networking_router_interface.k8s,
    ]

    name = "k8s-cluster"
    cluster_template_id = data.vkcs_kubernetes_clustertemplate.cluster_template.id
    master_flavor = data.vkcs_compute_flavor.k8s_master.id
    dns_domain = "cluster.local"
    master_count = 1
    availability_zone = "MS1"
    labels ={ 
        cluster_node_volume_type = var.k8s_master-volume_type
        ingress_controller = "nginx" 
    }
    network_id = vkcs_networking_network.k8s.id
    subnet_id = vkcs_networking_subnet.k8s-subnetwork.id
    floating_ip_enabled = true
}

resource "vkcs_kubernetes_node_group" "default_ng"{
    depends_on = [
        vkcs_kubernetes_cluster.k8s-cluster, 
    ] 
    cluster_id = vkcs_kubernetes_cluster.k8s-cluster.id 
    name = "default" 
    node_count = 1 
    autoscaling_enabled = true 
    max_nodes = 2 
    min_nodes = 1 
    flavor_id = data.vkcs_compute_flavor.k8s_worker.id 
    volume_type = var.k8s_worker-volume_type
    max_node_unavailable = 25
}

data "vkcs_kubernetes_cluster" "k8s-cluster" {
    depends_on = [
      vkcs_kubernetes_node_group.default_ng,
    ]
    name = "k8s-cluster"
}

resource "local_file" "kubeconfig" {
    content  = data.vkcs_kubernetes_cluster.k8s-cluster.k8s_config
    filename = "kube_config.yaml"
}