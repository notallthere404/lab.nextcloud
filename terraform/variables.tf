#### Replace these Values #######

variable "sshkey" {
  description = "Key name for ssh"
  type        = list(string)
  default = [
    "sshkey"
  ]
}

variable "cidr" {
  description = "Subnet CIDR"
  type        = list(string)
  default = [
    "192.168.94.0/24"
  ]
}

variable "ipstat" {
  description = "Static IP addresses"
  type        = list(string)
  default = [
    "192.168.94.10",
    "192.168.94.20"
  ]
}

variable "domain" {
  description = "domain address"
  type        = list(string)
  default = [
    "iths-seho.iths.lab.dsnw.dev.",
  ]
}

variable "netid" {
  description = "External network id"
  type        = list(string)
  default = [
    "f3fa073e-8038-44c4-ae42-64e2045ae538",
  ]
}


################### Do not need to change variables below ################### 

variable "zone" {
  description = "Availability zones"
  type        = list(string)
  default = [
    "nova-1",
    "nova-2",
    "nova-3",
    "nova-4",
    "nova-5"
  ]
}

variable "image" {
  description = "Image ids"
  type        = map(string)
  default = {
    "deb12" = "8d911bde-6b7d-4047-8d5f-24f4112cd2b3"
    "roc9"  = "cfe983d3-8995-43f3-9fed-ec76d83e2d41"
    "ubu22" = "148e0b66-aefa-43a9-9e49-af5a997138a7"
    "ubu24" = "e7605baf-b586-4987-9d4e-f69db1f64f57"
  }
}

variable "flavor" {
  description = "Flavor id"
  type        = map(string)
  default = {
    "m1.xlarge" = "4aaccfbf-e164-4864-85da-5a42d0cc6a9b"
    "m1.tiny"   = "5c7c1a44-05c6-4b19-a95e-64479f97cb2d"
    "m1.large"  = "7a205f0b-c159-43b6-8be5-e84ed5d510a7"
    "m1.small"  = "7cc3dd55-3a28-42be-a391-dbcac17667d4"
    "m1.medium" = "a4aba907-783c-4a43-8eb6-de29a07047c4"
    "m1.full"   = "e406bffa-ac20-422a-99a9-d3d397c22e45"
  }
}


