# Adding SSH access to the EC2 instance
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
  public_key = "*<SSH_KEY>*"
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
      cidr_blocks      = ["*<IPs>*/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "Security Group rule to allow download of necessary packages"
      from_port        = 0
      security_groups  = []
      self             = false
      prefix_list_ids  = []
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
}
```

Where *<SSH_KEY>* is your SSH public key and *<IPs>* is the list of IPs from where the node is going to be accessible (in this example you are gonna use your public IPv4).  
You could do something like, paste the above code block into a file named `main.tf` and then:

```bash
$ SSH_KEY=$(cat ~/.ssh/id_ed25519.pub)
$ IPs=$(curl ifconfig.so)
$ sed -i "s/\*<IPs>\*/$IPs/" main.tf
$ sed -i "s;\*<SSH_KEY>\*;$SSH_KEY;" main.tf
$ terraform init
$ terraform apply
$ RSK_NODE_IP=$(terraform output -json | jq -r .public_ip.value)
$ ssh -i ~/.ssh/id_ed25519 ubuntu@$RSK_NODE_IP
```

> You will need to define the provider configuration. You could use [provider.tf](./provider.tf)
