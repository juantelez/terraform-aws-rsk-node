output "public_ip" {
  description = "The public IP for the EC2 instance where your RSK node run"
  value       = module.ec2_instance.public_ip
}
output "aws_region" {
  description = "AWS region where the EC2 instance run"
  value       = data.aws_region.current.name
}
