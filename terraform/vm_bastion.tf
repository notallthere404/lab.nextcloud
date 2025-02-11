### Contains Bastion: Boot Volume | Compute Instance ###

resource "openstack_blockstorage_volume_v3" "bastion_boot_vol" {
  name              = "bastion boot volume"
  size              = 8
  image_id          = "e7605baf-b586-4987-9d4e-f69db1f64f57"
  description       = "Boot volume for bastion"
  availability_zone = var.zone[3]
}


resource "openstack_compute_instance_v2" "bastion" {
  name              = "bastion"
  image_id          = var.image["ubu24"]
  flavor_id         = var.flavor["m1.tiny"]
  key_pair          = openstack_compute_keypair_v2.keypair.name
  security_groups   = ["sg-bastion"]
  availability_zone = var.zone[3]
  network {
    uuid = openstack_networking_network_v2.internal.id
  }
  block_device {
    uuid                  = openstack_blockstorage_volume_v3.bastion_boot_vol.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }
}

