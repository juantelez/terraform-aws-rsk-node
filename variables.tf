variable "region" {
  description = "The AWS region where the RSKj node is gonna run"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "The name for your the EC2 instance that will be running the RSKj node"
  type        = string
  default     = "rsk-node"
}

variable "vpc_cidr" {
  description = "IPv4 private CIDR for the VPC"
  type        = string
}

variable "vpc_azs" {
  description = "List of Availability Zones for the VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_private_subnets" {
  description = "List of Private Subnets for the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnets" {
  description = "List of Public Subnets for the VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "your_public_ipv4" {
  description = "Public IPv4 that can access to the node using SSH"
  type        = list(string)
}

#variable "your_public_ipv6" {
#  description = "Public IPv6 that can access to the node using SSH"
#  type        = list(string)
#}
#
variable "rsk_mainnet_pd_port" {
  description = "Port number for RSK MainNet Peer Discovery protocol"
  type        = number
}

variable "rsk_testnet_pd_port" {
  description = "Port number for RSK TestNet Peer Discovery protocol"
  type        = number
}

variable "rsk_regtest_pd_port" {
  description = "Port number for RSK RegTest Peer Discovery protocol"
  type        = number
}
variable "rsk_network" {
  description = "RSK network could be MainNet, TestNet or RegTest (in lower-case)"
  type        = string
}
