# Load balancer

resource "openstack_blockstorage_volume_v3" "lb_boot_vol" {
  name              = "lb boot volume"
  size              = 8
  image_id          = var.image["ubu24"]
  description       = "Boot volume for lb"
  availability_zone = var.zone[4]
}

resource "openstack_compute_instance_v2" "lb" {
  name              = "lb"
  image_id          = var.image["ubu24"]
  flavor_id         = var.flavor["m1.small"]
  key_pair          = data.openstack_compute_keypair_v2.keypair.name
  security_groups   = ["sg-web-server"]
  availability_zone = var.zone[4]
  network {
    uuid = openstack_networking_network_v2.internal.id
  }
  block_device {
    uuid                  = openstack_blockstorage_volume_v3.lb_boot_vol.id
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }
  metadata = {
    group = "lb"
  }
}

data "openstack_dns_zone_v2" "zone" { name = "iths.lab.dsnw.dev." }

resource "openstack_dns_recordset_v2" "a-record" {
  zone_id = data.openstack_dns_zone_v2.zone.id
  name    = var.domain[0]
  ttl     = 10
  type    = "A"
  records = [openstack_networking_floatingip_v2.lb_fip.address]
}
