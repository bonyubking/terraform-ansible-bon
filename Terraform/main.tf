locals {
  keypair = aws_key_pair.myce_keypair.key_name
  project_name = "terra_bon"
}

module "vpc" {
  source      = "./modules/vpc"
  name_prefix = local.project_name
  vpc_cidr    = "10.0.0.0/16"

  subnets = {
    public1 = { cidr = "10.0.10.0/24", az = "ap-northeast-2a", public = true  }
    public2 = { cidr = "10.0.20.0/24", az = "ap-northeast-2b", public = true  }
    private1 = { cidr = "10.0.30.0/24", az = "ap-northeast-2a", public = false }
    private2 = { cidr = "10.0.40.0/24", az = "ap-northeast-2b", public = false }
  }
}

module "sg_groups" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
  sc_name_prefix = "myce-terra"
}



module "ec2_instances" {
  source = "./modules/ec2"
  key_name = local.keypair
  prefix   = local.project_name 

  instances = {
    private = {
      subnet  = module.vpc.private_subnets["private1"]
      sg      = module.sg_groups.private_sg_id
      public  = false
    }
    public = {
      subnet  = module.vpc.public_subnets["public1"]  
      sg      = module.sg_groups.public_sg_id
      public  = true
    }
    bastion = {
      subnet  = module.vpc.public_subnets["public1"]  
      sg      = module.sg_groups.bastion_sg_id
      public  = true
    }
    nat = {
      subnet  = module.vpc.public_subnets["public1"]  
      sg      = module.sg_groups.nat_sg_id
      public  = true
    }
  }
}


