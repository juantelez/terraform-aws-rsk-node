variable "region" {
  description = "The AWS region where the RSKj node is gonna run"
  type        = string
  default     = "us-east-1"
}

variable "name" {
  description = "The name for your the EC2 instance that will be running the RSKj node"
  type        = string
  default     = ""
}
