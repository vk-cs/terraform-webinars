resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

resource "vkcs_compute_keypair" "ssh" {
  name       = "terraform_ssh_key"
  public_key = tls_private_key.ssh.public_key_openssh
}

output "ssh" {
  value = tls_private_key.ssh.private_key_pem
  sensitive = true
}
