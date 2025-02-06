resource "openstack_networking_network_v2" "internal" {
  name           = "internal"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name            = "subnet"
  network_id      = openstack_networking_network_v2.internal.id
  cidr            = var.cidr[0]
  ip_version      = 4
  dns_nameservers = ["8.8.8.8"]
}

# Security group bastion SSH & ICMP

resource "openstack_networking_secgroup_v2" "sg-bastion" {
  name        = "sg-bastion"
  description = "Bastion secgroup that only allows ssh"
}

resource "openstack_networking_secgroup_rule_v2" "bastion_ssh_ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg-bastion.id
}

resource "openstack_networking_secgroup_rule_v2" "bastion_icmp_ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  security_group_id = openstack_networking_secgroup_v2.sg-bastion.id
}

resource "openstack_networking_secgroup_rule_v2" "bastion_icmp_egress" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  security_group_id = openstack_networking_secgroup_v2.sg-bastion.id
}

# Security group WebServers SSH & HTTP(S)
resource "openstack_networking_secgroup_v2" "sg-web-server" {
  name        = "sg-web-server"
  description = "web server security group"
}

resource "openstack_networking_secgroup_rule_v2" "web_server_ssh_ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id   = openstack_networking_secgroup_v2.sg-bastion.id
  security_group_id = openstack_networking_secgroup_v2.sg-web-server.id
  description       = "Allow SSH from the Bastion Security Group"
}

resource "openstack_networking_secgroup_rule_v2" "web_server_http_ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg-web-server.id
  description       = "Allow HTTP from the Internet"
}

resource "openstack_networking_secgroup_rule_v2" "web_server_https_ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg-web-server.id
  description       = "Allow HTTPS from the Internet"
}

# External network/router
resource "openstack_networking_router_v2" "router" {
  name                = "router"
  admin_state_up      = true
  external_network_id = "f3fa073e-8038-44c4-ae42-64e2045ae538"
}
resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}

# Floating IP for bastion
resource "openstack_networking_floatingip_v2" "bastion_fip" {
  pool = "external-net"
}

resource "openstack_compute_floatingip_associate_v2" "bastion_fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.bastion_fip.address
  instance_id = openstack_compute_instance_v2.bastion.id
}

# Floating IP for web server
resource "openstack_networking_floatingip_v2" "webserver_fip" {
  pool = "external-net"
}

resource "openstack_compute_floatingip_associate_v2" "webserver_fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.webserver_fip.address
  instance_id = openstack_compute_instance_v2.webserver.id
}

data "openstack_dns_zone_v2" "zone" { name = "iths.lab.dsnw.dev." }

resource "openstack_dns_recordset_v2" "a-record" {
  zone_id = data.openstack_dns_zone_v2.zone.id
  name    = var.domain[0]
  ttl     = 10
  type    = "A"
  records = [openstack_networking_floatingip_v2.webserver.address]
}
