# database

resource "openstack_blockstorage_volume_v3" "db_boot_vol" {
  name              = "Database boot volume"
  size              = 8
  image_id          = var.image["ubu24"]
  description       = "Boot volume for db"
  availability_zone = "nova-5"
}

resource "openstack_compute_instance_v2" "db" {
  name              = "db"
  image_id          = var.image["ubu24"]
  flavor_id         = var.flavor["m1.small"]
  key_pair          = openstack_compute_keypair_v2.keypair.name
  security_groups   = ["sg-db-server"]
  availability_zone = "nova-5"
  network {
    uuid = openstack_networking_network_v2.internal.id
  }
  block_device {
    uuid                  = openstack_blockstorage_volume_v3.db_boot_vol.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }
  metadata = {
    role = "database"
  }
}
