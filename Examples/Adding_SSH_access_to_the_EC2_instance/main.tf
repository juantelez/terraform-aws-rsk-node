module "rsk-node" {
  source  = "app.terraform.io/juan-rsk-test/rsk-node/aws"
  version = "1.0.3"

  rsk_network = var.rsk_network

  key_name = aws_key_pair.deployer.key_name

  additional_security_group_ids = [module.ssh_security_group.security_group_id]
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "<SSH_KEY>"
}

module "ssh_security_group" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name = "Allow SSH access"

  vpc_id = data.aws_vpc.default.id

  ingress_cidr_blocks = ["<IPs>/32"]
}
