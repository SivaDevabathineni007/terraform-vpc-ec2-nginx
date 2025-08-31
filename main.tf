module "network" {
  source          = "./modules/vpc"
  name            = var.name
  vpc_cidr_block  = var.vpc_cidr_block
  az_count        = var.az_count
}

module "web" {
  source        = "./modules/instance"
  name          = var.name
  subnet_id     = module.network.public_subnet_ids[0]
  vpc_id        = module.network.vpc_id
  instance_type = var.instance_type
  enable_nginx  = var.enable_nginx
}

