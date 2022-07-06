data "vkcs_compute_flavor" "db_flavor" {
    name = var.db-instance-flavor
}

resource "vkcs_db_instance" "db-instance" {
  depends_on = [
      vkcs_networking_router_interface.k8s,
  ]
  name        = "db-instance"

  datastore {
    type    = "mysql"
    version = "8.0"
  }

  flavor_id   = data.vkcs_compute_flavor.db_flavor.id
  size        = 8
  volume_type = "high-iops"
  disk_autoexpand {
    autoexpand    = true
    max_disk_size = 1000
  }

  network {
    uuid = vkcs_networking_network.k8s.id
  }
}

resource "vkcs_db_database" "db-database" {
  name        = "wordpress"
  dbms_id = vkcs_db_instance.db-instance.id
  charset     = "utf8"
  collate     = "utf8_general_ci"
}

resource "vkcs_db_user" "db-user" {
  name        = "wordpress"
  password    = var.DB_USER_PASSWORD

  dbms_id = vkcs_db_instance.db-instance.id

  databases   = [vkcs_db_database.db-database.name]
}