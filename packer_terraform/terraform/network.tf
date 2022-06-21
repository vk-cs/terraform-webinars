data "vkcs_networking_network" "extnet" {
  name = "ext-net"
}

resource "vkcs_networking_network" "example_routed_private_network" {
  name = "example_routed_private_network"
}

resource "vkcs_networking_subnet" "example_routed_private_subnet" {
  name        = "example_routed_private_subnet"
  network_id  = vkcs_networking_network.example_routed_private_network.id
  cidr        = "10.0.2.0/24"
  ip_version  = 4
  enable_dhcp = true
}

resource "vkcs_networking_router" "example_router" {
  name                = "example_router"
  external_network_id = data.vkcs_networking_network.extnet.id
}

resource "vkcs_networking_router_interface" "example_router_interface" {
  router_id = vkcs_networking_router.example_router.id
  subnet_id = vkcs_networking_subnet.example_routed_private_subnet.id
}

resource "vkcs_networking_secgroup" "secgroup" {
  name        = "terraform__security_group"
  description = "security group for terraform instance"
}

resource "vkcs_networking_secgroup_rule" "secgroup_rule22" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${vkcs_networking_secgroup.secgroup.id}"
}

resource "vkcs_networking_secgroup_rule" "secgroup_rule80" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${vkcs_networking_secgroup.secgroup.id}"
}

resource "vkcs_networking_secgroup_rule" "secgroup_rule-1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${vkcs_networking_secgroup.secgroup.id}"
}
