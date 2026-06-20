# modules/ec2/variables.tf

variable "environment" {
  description = "Environment name (dev or qa)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance size"
  type        = string
}

variable "vpc_id" {
  description = "VPC to place the instance in"
  type        = string
}

variable "subnet_id" {
  description = "Subnet to launch the instance into"
  type        = string
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH"
  type        = list(string)
}
