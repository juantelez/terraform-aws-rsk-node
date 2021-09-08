RSK Node Terraform Module
=========================

Terraform [module](https://www.terraform.io/docs/language/modules/index.html) which provision the needing infraestructure to run a RSK node on an EC2 AWS instance.

The most important things that this module will create are:
* an EC2 instance (using a default type `t3a.large`  
* a Security Group to allow world access through SSH protocol to the instance.
* a Security Group to allow world access to RSK Peer Discovery

Usage
-----

TODO
----
