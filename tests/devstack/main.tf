terraform {
  required_version = ">= 0.12"
}

module "openstack" {
  source = "../../openstack"

  cluster_name = "foufounes"
  domain       = "calculquebec.cloud"
  image        = "CentOS-7-x86_64-GenericCloud-1907"
  nb_users     = 10

  instances = {
    mgmt  = { type = "m1.large", count = 1 },
    login = { type = "m1.medium", count = 1 },
    node  = { type = "m1.medium", count = 1 }
  }

  storage = {
    type         = "nfs"
    home_size    = 5
    project_size = 5
    scratch_size = 5
  }

  public_keys = [file("~/.ssh/id_rsa.pub")]

  # Shared password, randomly chosen if blank
  guest_passwd = ""

  # OpenStack specific
  os_floating_ips = []

  os_int_network = "private"
  os_int_subnet  = "private-subnet"
}

output "sudoer_username" {
  value = module.openstack.sudoer_username
}

output "guest_usernames" {
  value = module.openstack.guest_usernames
}

output "guest_passwd" {
  value = module.openstack.guest_passwd
}

output "public_ip" {
  value = module.openstack.ip
}

module "dns" {
  source           = "git::https://github.com/ComputeCanada/magic_castle.git//dns/cloudflare"
  email            = "simon.guilbault@calculquebec.ca"
  name             = module.openstack.cluster_name
  domain           = module.openstack.domain
  public_ip        = module.openstack.ip
  rsa_public_key   = module.openstack.rsa_public_key
  sudoer_username  = module.openstack.sudoer_username
}

output "hostnames" {
  value = module.dns.hostnames
}
