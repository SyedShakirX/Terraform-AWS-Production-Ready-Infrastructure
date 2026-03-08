module "networking" {
  source        = "./modules/networking"
  vpc_cidr      = var.vpc_cidr
  internet_cidr = var.internet_cidr
  ec2_ports     = var.ec2_ports
  alb_ports     = var.alb_ports
}

module "compute" {
  depends_on             = [module.networking]
  source                 = "./modules/compute"
  ssh_key                = var.ssh_key
  bastion_ami            = var.bastion_ami
  bastion_type           = var.bastion_type
  shakirs_pub_sn_1a      = module.networking.shakirs_pub_sn_1a
  shakirs_pub_sn_1b      = module.networking.shakirs_pub_sn_1b
  shakirs_pvt_sn_1a      = module.networking.shakirs_pvt_sn_1a
  shakirs_pvt_sn_1b      = module.networking.shakirs_pvt_sn_1b
  security_group_bastion = module.networking.security_group_bastion
  asg_ec2_ami            = var.asg_ec2_ami
  asg_ec2_type           = var.asg_ec2_type
  security_group_asg_ec2 = module.networking.security_group_asg_ec2


}

module "alb" {
  source             = "./modules/alb"
  security_group_alb = module.networking.security_group_alb
  shakirs_pub_sn_1a  = module.networking.shakirs_pub_sn_1a
  shakirs_pub_sn_1b  = module.networking.shakirs_pub_sn_1b
  shakirs_vpc        = module.networking.shakirs_vpc
  private_ec2_asg    = module.compute.private_ec2_asg
}