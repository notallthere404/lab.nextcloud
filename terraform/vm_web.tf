### Contains Webserver: Boot Volume | Compute Instance ###

resource "openstack_blockstorage_volume_v3" "webserver-boot-vol" {
  name              = "web-boot-vol"
  size              = 40
  image_id          = var.image["ubu22"]
  description       = "Boot volume for web"
  availability_zone = var.zone[1]
}

resource "openstack_compute_instance_v2" "webserver" {
  name              = "webserver"
  image_id          = var.image["ubu22"]
  flavor_id         = var.flavor["m1.xlarge"]
  key_pair          = openstack_compute_keypair_v2.keypair.name
  security_groups   = ["sg-web-server"]
  availability_zone = var.zone[1]
  network {
    uuid = openstack_networking_network_v2.internal.id
  }
  block_device {
    uuid                  = openstack_blockstorage_volume_v3.webserver-boot-vol.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }
}
