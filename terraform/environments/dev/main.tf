locals {
  name = "zuri-${var.environment}"
}

module "network" {
  source              = "../../modules/network"
  name                = local.name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  admin_cidr          = var.admin_cidr
}

module "secrets" {
  source      = "../../modules/secrets"
  secret_name = "zuri/${var.environment}/backend"
}

module "iam" {
  source     = "../../modules/iam"
  name       = local.name
  secret_arn = module.secrets.secret_arn
}

module "compute" {
  source                  = "../../modules/compute"
  name                    = local.name
  instance_type           = var.instance_type
  subnet_id               = module.network.public_subnet_id
  security_group_ids      = [module.network.app_sg_id]
  instance_profile_name   = module.iam.instance_profile_name
  healthcheck_script_path = "${path.root}/../../../scripts/healthcheck.sh"
  health_check_cron       = var.health_check_cron
}
