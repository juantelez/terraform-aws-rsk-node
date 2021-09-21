# Provisioning the infra with the  Terraform module

## Summary
Terraform [module](https://www.terraform.io/docs/language/modules/index.html) which provision the needing infraestructure to run a RSK node on an EC2 AWS instance.

The most important things that this module will create are:
* an EC2 instance (using a default type `t3a.large`  
* a Security Group to allow world access to RSK Peer Discovery

Required arguments:

* `rsk_network`: Could be one of `mainnet`, `testnet` or `regtest`
* `region`: The AWS region where the RSKj node is gonna run.

## Usage examples
* [Adding SSH access to the EC2 instance](./Examples/AllowSSH.md)

# Intalling and configuring the app with Ansible playbook
Inside directory [ansible/](./ansible/) you will find the `deploy-rsk-node.yml` playbook to install, configure and spin up the node.  
To run it, you just need to:
```bash
$ echo -e "[rsk-host]"\n $RSK_NODE_IP > inventory
$ ansible-playbook -u ubuntu -i inventory deploy-rsk-node.yml
```
