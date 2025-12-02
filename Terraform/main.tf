locals {
  keypair = "terra_myce_keypair"
  project_name = "terra-bon"
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
  private_rt_id = module.vpc.private_rt_id 

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


module "rds_mysql" {

  source = "./modules/rds"
  prefix = local.project_name
  security_groups = [module.sg_groups.mysql_sg_id]
  sb = module.vpc.private_subnets
  db_pw = var.db_pw
  db_name = var.db_name
  username = var.username
}

resource "aws_route" "private_to_nat" {
  route_table_id         = module.vpc.private_rt_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.ec2_instances.nat_eni_id
}

data "aws_s3_bucket" "artifact_bucket" {
  bucket = "bon-artifact-bucket"
}

resource "aws_s3_object" "ansible_inventory_upload" {
  bucket = data.aws_s3_bucket.artifact_bucket.id
  key    = "hosts.ini"        
  content = <<-EOT
    [bastion]
    bastion1 ansible_host=${module.ec2_instances.public_ips["bastion"]}

    [nat]
    nat1 ansible_host=${module.ec2_instances.public_ips["nat"]}

    [public]
    public1 ansible_host=${module.ec2_instances.public_ips["public"]}

    [private]
    private1 ansible_host=${module.ec2_instances.private_ip["private"]}

    [private:vars]
    ansible_ssh_common_args='-o ProxyCommand="ssh -i ./terra_myce_keypair.pem -W %h:%p -o StrictHostKeyChecking=no ec2-user@${module.ec2_instances.public_ips["bastion"]}"'
    EOT
  depends_on = [
    module.ec2_instances
  ]
}

