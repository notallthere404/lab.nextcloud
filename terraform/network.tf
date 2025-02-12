## Contains Network | Security Groups | Floating IP ##

### Internal Network ###
resource "openstack_networking_network_v2" "internal" {
  name           = "internal"
  admin_state_up = "true"
}

# Subnet
resource "openstack_networking_subnet_v2" "subnet" {
  name            = "subnet"
  network_id      = openstack_networking_network_v2.internal.id
  cidr            = "194.168.94.0/24"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8"]
}

# Router
resource "openstack_networking_router_v2" "router" {
  name                = "router"
  admin_state_up      = true
  external_network_id = "f3fa073e-8038-44c4-ae42-64e2045ae538"
}

# Router Interface
resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}

# Security group Bastion
resource "openstack_networking_secgroup_v2" "sg-bastion" {
  name        = "sg-bastion"
  description = "Bastion secgroup that only allows ssh"
}

# Rule SSH in Bastion
resource "openstack_networking_secgroup_rule_v2" "bastion_ssh_ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.sg-bastion.id
}

# Rule ping in Bastion
resource "openstack_networking_secgroup_rule_v2" "bastion_icmp_ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  security_group_id = openstack_networking_secgroup_v2.sg-bastion.id
}

# Rule ping out Bastion
resource "openstack_networking_secgroup_rule_v2" "bastion_icmp_egress" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  security_group_id = openstack_networking_secgroup_v2.sg-bastion.id
}

### Security group Webserver ###
resource "openstack_networking_secgroup_v2" "sg-web-server" {
  name        = "sg-web-server"
  description = "web server security group"
}

# Rule SSH in Webserver from Bastion
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

# Rule HTTP in Webserver
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

# Floating IP Bastion
resource "openstack_networking_floatingip_v2" "bastion_fip" {
  pool = "external-net"
}
resource "openstack_compute_floatingip_associate_v2" "bastion_fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.bastion_fip.address
  instance_id = openstack_compute_instance_v2.bastion.id
}

# Floating IP Webserver
resource "openstack_networking_floatingip_v2" "webserver_fip" {
  pool = "external-net"
}
resource "openstack_compute_floatingip_associate_v2" "webserver_fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.webserver_fip.address
  instance_id = openstack_compute_instance_v2.webserver.id
}
