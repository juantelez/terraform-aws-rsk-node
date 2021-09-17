variable "vpc_id" {
  description = "The ID of the VPC in which the nodes will be deployed. Uses default VPC if not supplied."
  type        = string
  default     = null
}

variable "name" {
  description = "The name for your the EC2 instance that will be running the RSKj node"
  type        = string
  default     = "rsk-node"
}

variable "rsk_network" {
  description = "RSK network name. One of \"mainnet\", \"testnet\" or \"regtest\"."
  type        = string

  validation {
    condition     = anytrue([for network in ["mainnet", "testnet", "regtest"] : lower(var.rsk_network) == network])
    error_message = "Only \"mainnet\", \"testnet\" or \"regtest\" allowed."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3a.large"
}

variable "key_name" {
  description = "Name of the keypair for SSH access (must exists on the AWS region)."
  type        = string
  default     = null
}

variable "additional_security_group_ids" {
  description = "List of security group IDs to associate with"
  type        = list(string)
  default     = []
}
