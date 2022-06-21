resource "vkcs_compute_instance" "instance" {
  count = var.node_count
  name = "node-${count.index}"

  image_name = "${var.image_name}-${var.image_tag}"

  flavor_name = var.flavor_name

  key_pair = vkcs_compute_keypair.ssh.name

  config_drive = true

  security_groups = [
    vkcs_networking_secgroup.secgroup.name
  ]

  network {
    name = vkcs_networking_network.example_routed_private_network.name
  }

  lifecycle {
    create_before_destroy = true
  }
}