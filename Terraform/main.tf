locals{
  keypair = aws_key_pair.myce_keypair.key_name
}

module "sg_groups" {
  source = "./modules/sg"
  vpc_id = aws_vpc.vpc.id
}

module "private_terra_server" {
  source = "./modules/ec2"

  name              = "myce_private_terra"
  key_name          = local.keypair
  subnet_id         = aws_subnet.bon-terraform-subnet-private1.id
  security_group_ids = [module.sg_groups.private_sg_id]
  use_public_ip = false
}

module "public_terra_server" {
  source = "./modules/ec2"

  name              = "myce_public_terra"
  subnet_id         = aws_subnet.bon-terraform-subnet-public1.id
  key_name          = local.keypair
  security_group_ids = [module.sg_groups.public_sg_id]
}

module "bastion_terra_server" {
  source = "./modules/ec2"

  name              = "myce_bastion_terra"
  subnet_id         = aws_subnet.bon-terraform-subnet-public1.id
  key_name          = local.keypair
  security_group_ids = [module.sg_groups.bastion_sg_id]
}

module "nat_terra_server" {
  source = "./modules/ec2"

  name              = "myce_nat_terra"
  subnet_id         = aws_subnet.bon-terraform-subnet-public1.id
  key_name          = local.keypair
  security_group_ids = [module.sg_groups.nat_sg_id]

}