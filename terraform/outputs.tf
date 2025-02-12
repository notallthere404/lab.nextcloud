### IP Outputs ###

# Floating IP Bastion
output "bastion_fip" {
  value       = openstack_networking_floatingip_v2.bastion_fip.address
  description = "Floating IP associated to the bastion VM"
}

# Floating IP Webserver
output "webserver_fip" {
  value       = openstack_networking_floatingip_v2.webserver_fip.address
  description = "Floating IP associated to the webserver"
}

# Internal IP Webserver
output "webserver_ip" {
  value = openstack_compute_instance_v2.webserver.access_ip_v4
}
