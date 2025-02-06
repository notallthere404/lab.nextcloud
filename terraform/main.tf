terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}
provider "openstack" {
  cloud = "openstack"
}
/*
resource "openstack_compute_keypair_v2" "keypair" {
  name       = "iths-lab-env-keypair"
  public_key = file("~/.ssh/3iths-lab-env.pub")
}
*/

data "openstack_compute_keypair_v2" "keypair" {
  name = "httpserverkey"
}
