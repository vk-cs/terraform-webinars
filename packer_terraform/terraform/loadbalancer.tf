resource "vkcs_networking_floatingip" "example_floating_ip" {
  pool    = "ext-net"
  port_id = vkcs_lb_loadbalancer.example_http_balancer.vip_port_id
}

resource "vkcs_lb_loadbalancer" "example_http_balancer" {
  name          = "example_http_balancer"
  description   = "An HTTP load balancer in a private network with 2 backends"
  vip_subnet_id = vkcs_networking_subnet.example_routed_private_subnet.id
}

resource "vkcs_lb_listener" "example_http_listener" {
  name            = "example_http_listener"
  description     = "A load balancer frontend that listens on 80 prot for client traffic"
  protocol        = "HTTP"
  protocol_port   = 80
  loadbalancer_id = vkcs_lb_loadbalancer.example_http_balancer.id
}

resource "vkcs_lb_pool" "example_http_pool" {
  name        = "example_http_pool"
  description = "A load balancer pool of backends with Round-Robin algorithm to distribute traffic to pool's members"
  protocol    = "HTTP"
  lb_method   = "ROUND_ROBIN"
  listener_id = vkcs_lb_listener.example_http_listener.id
}

resource "vkcs_lb_monitor" example_http_monitor {
  name           = "example_http_monitor"
  delay          = 5
  max_retries    = 3
  timeout        = 5
  type           = "HTTP"
  url_path       = "/"
  http_method    = "GET"
  expected_codes = "200"
  pool_id        = vkcs_lb_pool.example_http_pool.id
}

resource "vkcs_lb_member" "example_http_member" {
  count         = var.node_count
  name          = "example_http_member-${count.index}"
  address       = vkcs_compute_instance.instance.*.access_ip_v4[count.index]
  protocol_port = 80
  weight        = 10
  pool_id       = vkcs_lb_pool.example_http_pool.id
  subnet_id     = vkcs_networking_subnet.example_routed_private_subnet.id

  lifecycle {
    create_before_destroy = true
  }
}

output "example_http_balancer_vip_address" {
  value = vkcs_networking_floatingip.example_floating_ip.address
}
