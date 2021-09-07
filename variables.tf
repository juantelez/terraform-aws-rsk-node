variable "region" {
  description = "The AWS region where the RSKj node is gonna run"
  type        = string
  default     = "us-east-1"
}

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
  description = "RSK network could be MainNet, TestNet or RegTest"
  type        = string

  validation {
    condition     = var.rsk_network == "mainnet" || var.rsk_network == "testnet" || var.rsk_network == "regtest"
    error_message = "RSK network name (ie, mainnet, testnet or regtest)."
  }
}

variable "rsk_mainnet_pd_port" {
  description = "Port number for RSK MainNet Peer Discovery protocol"
  type        = number
  default     = 5055
}

variable "rsk_testnet_pd_port" {
  description = "Port number for RSK TestNet Peer Discovery protocol"
  type        = number
  default     = 50505
}

variable "rsk_regtest_pd_port" {
  description = "Port number for RSK RegTest Peer Discovery protocol"
  type        = number
  default     = 50501
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3a.large"
}
