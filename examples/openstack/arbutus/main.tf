module "openstack" {
  source = "git::ssh://gitlab@git.computecanada.ca/fafor10/slurm_cloud.git//openstack"

  # JupyterHub + Slurm definition
  cluster_name        = "phoenix"
  domain              = "calculquebec.cloud"
  nb_nodes            = 5
  nb_users            = 10
  shared_storage_size = 100
  public_key_path     = "./pub.key"
  globus_user         = ""
  globus_password     = ""

  # OpenStack specifics
  os_external_network  = "Public-Network"
  os_image_name        = "CentOS-7-x64-2018-09"
  os_flavor_node       = "p2-3gb"
  os_flavor_login      = "p2-3gb"
  os_flavor_mgmt       = "p4-6gb"
  os_floating_ip       = ""
}

## Uncomment to register your domain name with CloudFlare
# module "dns" {
#   source           = "git::ssh://gitlab@git.computecanada.ca/fafor10/slurm_cloud.git//dns/cloudflare"
#   name             = "${module.openstack.cluster_name}"
#   domain           = "${module.openstack.domain}"
#   public_ip        = "${module.openstack.ip}"
#   rsa_public_key   = "${module.openstack.rsa_public_key}"
#   ecdsa_public_key = "${module.openstack.ecdsa_public_key}"
# }

output "public_ip" {
	value = "${module.openstack.ip}"
}

output "domain_name" {
	value = "${module.openstack.domain_name}"
}

output "admin_passwd" {
	value = "${module.openstack.admin_passwd}"
}

output "guest_passwd" {
	value = "${module.openstack.guest_passwd}"
}
