terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.0.0"

  name = "vpc-rsk-node"
  cidr = var.vpc_cidr

  azs                         = var.vpc_azs
  private_subnets             = var.vpc_private_subnets
  public_subnets              = var.vpc_public_subnets
  public_subnet_ipv6_prefixes = var.vpc_public_subnet_ipv6_prefixes

  enable_ipv6                                    = true
  public_subnet_assign_ipv6_address_on_creation  = true
  create_egress_only_igw                         = false
  private_subnet_assign_ipv6_address_on_creation = false

}

module "ssh_access_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/ssh"
  version = "4.0.0"

  name        = "ssh-access"
  description = "Allow SSH access to the RSK node"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks      = var.your_public_ipv4
  ingress_ipv6_cidr_blocks = var.your_public_ipv6
  auto_ingress_with_self   = []
}

module "rsk_pd_sg" {
  for_each = {
    MainNet = var.rsk_mainnet_pd_port
    TestNet = var.rsk_testnet_pd_port
    RegTest = var.rsk_regtest_pd_port
  }

  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"

  name        = "rsk-${lower(each.key)}-pd"
  description = "Allow world access to RSK ${each.key} Peer Discovery"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]
  ingress_with_cidr_blocks = [
    {
      from_port = each.value
      to_port   = each.value
      protocol  = "tcp"
    },
    {
      from_port = each.value
      to_port   = each.value
      protocol  = "udp"
    },
  ]
  ingress_with_ipv6_cidr_blocks = [
    {
      from_port = each.value
      to_port   = each.value
      protocol  = "tcp"
    },
    {
      from_port = each.value
      to_port   = each.value
      protocol  = "udp"
    },
  ]
}

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.1.0"

  name = var.name

  ami = "ami-05e56ad87552fc2cb"

  instance_type = "m5a.large"

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = 100
    }
  ]

  subnet_id = module.vpc.public_subnets

  vpc_security_group_ids = [
    module.ssh_access_sg.security_group_id,
  ]
}
