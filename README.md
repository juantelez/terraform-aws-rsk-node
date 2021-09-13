# RSK Node Terraform Module

## Summary
Terraform [module](https://www.terraform.io/docs/language/modules/index.html) which provision the needing infraestructure to run a RSK node on an EC2 AWS instance.

The most important things that this module will create are:
* an EC2 instance (using a default type `t3a.large`  
* a Security Group to allow world access to RSK Peer Discovery

## Usage expamples
### Adding SSH access to the EC2 instance
```hcl
module "rsk-node" {
  source  = "app.terraform.io/juan-rsk-test/rsk-node/aws"
  version = "0.1.6"

  rsk_network = "testnet"

  key_name = aws_key_pair.deployer.key_name

  additional_security_group_ids = [aws_security_group.allow_ssh.id]
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "<YOUR SSH PUBLIC KEY>"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      description      = "TLS from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [<LIST OF IPS FROM WHERE THE NODE IS GONNA BE ACCESSIBLE>]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}
```




Required arguments:

* `rsk_network`: Could be one of `mainnet`, `testnet` or `regtest`
* `region`: The AWS region where the RSKj node is gonna run.


