# Adding SSH access to the EC2 instance
In `main.tf` replace *\<SSH_KEY>* with your SSH public key and *\<IPs>* with the list of IPs from where the node is going to be accessible.  
> For example: the content of `~/.ssh/id_ed25519` is a valid value for `public_key`

Then you could provision the infra and access your new instance doing:
```bash
$ terraform init
$ terraform apply
$ RSK_NODE_IP=$(terraform output -raw public_ip)
$ ssh -i ~/.ssh/id_ed25519 ubuntu@$RSK_NODE_IP
```
