# Provisioning the infrastructure to run an RSKj node using Terraform module

## Summary
Terraform [module](https://www.terraform.io/docs/language/modules/index.html) which provision the needing infraestructure to run a RSK node on an EC2 AWS instance.

The most important things that this module will create are:
* an EC2 instance (using a default type `t3a.large`).  
* a Security Group to allow world access to RSK Peer Discovery.

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
|additional_security_group_ids|List of security group IDs to associate with|`list`|`[]`|no|
|instance_type|EC2 instance type|`string`|`"t3a.large"`|no|
|key_name|Name of the keypair for SSH access (must exists on the AWS region<sup>Note</sup>).|`string`| `null`|no|
|name|The name for your the EC2 instance that will be running the RSKj node.|`string`|`"rsk-node"`|no|
| rsk_network | Could be one of `mainnet`, `testnet` or `regtest`. Refere to [RSK Dev portal](https://developers.rsk.co/rsk/node/configure/reference/#blockchainconfigname) for more details | `string` |`n/a` | yes |
|vpc_id|The ID of the VPC in which the nodes will be deployed. Uses default VPC if not supplied.|`string`|`null`|no|

<sup>Note</sup> Or you could instruct Terraform to create one from a SSH's public key, as shown in this [example](./Examples/Adding_SSH_access_to_the_EC2_instance.md)

## Outputs
| Name | Description |
|------|-------------|
| public_ip | The public IP address of the instance |

## Usage examples
* [Adding SSH access to the EC2 instance](./Examples/Adding_SSH_access_to_the_EC2_instance.md)

# Intalling and configuring the RSKj node using Ansible playbook
Inside directory [ansible/](./ansible/) you will find the `deploy-rsk-node.yml` playbook to install, configure and spin up the node.  
To run it, you just need to:
```bash
$ echo -e "[rsk-host]\n $RSK_NODE_IP" > inventory
$ ansible-playbook -u ubuntu -i inventory deploy-rsk-node.yml
```

