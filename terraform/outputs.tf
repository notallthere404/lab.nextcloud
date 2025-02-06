# Floating IP Output
output "bastion_fip" {
  value       = openstack_networking_floatingip_v2.bastion_fip.address
  description = "Floating IP associated to the bastion VM"
}

output "webserver_fip" {
  value       = openstack_networking_floatingip_v2.webserver_fip.address
  description = "Floating IP associated to the load balancer VM"
}

# Internal IP output
output "webserver_ip" {
  value = openstack_compute_instance_v2.webserver.access_ip_v4
}
