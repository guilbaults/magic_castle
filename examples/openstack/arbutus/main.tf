module "openstack" {
  source = "git::ssh://gitlab@git.computecanada.ca/fafor10/slurm_cloud.git//openstack"

  # JupyterHub + Slurm definition
  cluster_name        = "phoenix"
  nb_nodes            = 5
  nb_users            = 10
  shared_storage_size = 100
  domain_name         = "jupyter2.calculquebec.cloud"
  public_key_path     = "./pub.key"

  # OpenStack specifics
  os_external_network  = "Public-Network"
  os_image_id          = "ca4f2334-cdbd-405f-943a-258657a81d1f"
  os_flavor_node       = "p2-3gb"
  os_flavor_login      = "p2-3gb"
  os_flavor_mgmt       = "p4-6gb"
  os_availability_zone = "Compute"
}

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
