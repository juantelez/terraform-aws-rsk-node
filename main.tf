terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.56.0"
    }
  }
}

data "aws_region" "current" {}

data "aws_vpc" "default" {
  default = var.vpc_id == null ? true : false
  id      = var.vpc_id
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

locals {
  rsk_pd_ports_map = {
    mainnet = 5050
    testnet = 50505
    regtest = 50501
  }
  rsk_pd_port = local.rsk_pd_ports_map[lower(var.rsk_network)]
}

module "rsk_pd_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"

  name        = "rsk-${lower(var.rsk_network)}-peer-discovery"
  description = "Allow world access to RSK ${lower(var.rsk_network)} Peer Discovery"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_ipv6_cidr_blocks = ["::/0"]

  ingress_with_cidr_blocks = [
    {
      from_port = local.rsk_pd_port
      to_port   = local.rsk_pd_port
      protocol  = "tcp"
    },
    {
      from_port = local.rsk_pd_port
      to_port   = local.rsk_pd_port
      protocol  = "udp"
    },
  ]
  ingress_with_ipv6_cidr_blocks = [
    {
      from_port = local.rsk_pd_port
      to_port   = local.rsk_pd_port
      protocol  = "tcp"
    },
    {
      from_port = local.rsk_pd_port
      to_port   = local.rsk_pd_port
      protocol  = "udp"
    },
  ]
}

module "exit_to_Inet_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"

  name        = "exit-to-Inet-sg"
  description = "Allow access from RSK ${lower(var.rsk_network)} to the Internet."
  vpc_id      = data.aws_vpc.default.id

  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_ipv6_cidr_blocks = ["::/0"]
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "3.1.0"

  name = var.name

  ami = data.aws_ami.ubuntu.id

  instance_type = var.instance_type

  key_name = var.key_name

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = 200
    }
  ]

  subnet_id = data.aws_subnets.default.ids[0]

  vpc_security_group_ids = concat(
    [module.rsk_pd_sg.security_group_id],
    var.additional_security_group_ids,
  )
}
