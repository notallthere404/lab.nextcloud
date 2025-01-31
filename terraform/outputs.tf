# Floating IP Output
output "bastion_fip" {
  value       = openstack_networking_floatingip_v2.bastion_fip.address
  description = "Floating IP associated to the bastion VM"
}

output "lb_fip" {
  value       = openstack_networking_floatingip_v2.lb_fip.address
  description = "Floating IP associated to the load balancer VM"
}

# Internal IP output
output "web_server_1_ip" {
  value = openstack_compute_instance_v2.web-1.access_ip_v4
}

output "web_server_2_ip" {
  value = openstack_compute_instance_v2.web-2.access_ip_v4
}
