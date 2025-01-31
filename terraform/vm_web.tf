# Web servers and boot volumes

resource "openstack_blockstorage_volume_v3" "web-boot-vol1" {
  name              = "web-boot-vol1"
  size              = 8
  image_id          = var.image["ubu22"]
  description       = "Boot volume for web-1"
  availability_zone = var.zone[1]
}

resource "openstack_blockstorage_volume_v3" "web-boot-vol2" {
  name              = "web-boot-vol2"
  size              = 8
  image_id          = var.image["ubu22"]
  description       = "Boot volume for web-2"
  availability_zone = var.zone[2]
}

resource "openstack_compute_instance_v2" "web-1" {
  name              = "web-1"
  image_id          = var.image["ubu22"]
  flavor_id         = var.flavor["m1.small"]
  key_pair          = data.openstack_compute_keypair_v2.os_kp.name
  security_groups   = ["sg-web-server"]
  availability_zone = var.zone[1]
  network {
    uuid        = openstack_networking_network_v2.internal.id
    fixed_ip_v4 = var.ipstat[0]
  }
  block_device {
    uuid                  = openstack_blockstorage_volume_v3.web-boot-vol1.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }
  metadata = {
    group = "web"
  }
}

resource "openstack_compute_instance_v2" "web-2" {
  name              = "web-2"
  image_id          = var.image["ubu22"]
  flavor_id         = var.flavor["m1.small"]
  key_pair          = data.openstack_compute_keypair_v2.os_kp.name
  security_groups   = ["sg-web-server"]
  availability_zone = var.zone[2]
  network {
    uuid        = openstack_networking_network_v2.internal.id
    fixed_ip_v4 = var.ipstat[1]
  }
  block_device {
    uuid                  = openstack_blockstorage_volume_v3.web-boot-vol2.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }
  metadata = {
    group = "web"
  }
}
