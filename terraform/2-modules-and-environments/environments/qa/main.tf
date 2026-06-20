# environments/dev/main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Find the default VPC and its subnets (keeps the example easy to run).
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Build the EC2 instance from the ec2 module.
module "ec2" {
  source = "../../modules/ec2"

  #environment       = var.environment
  environment       = "qa"
  instance_type     = var.instance_type
  vpc_id            = data.aws_vpc.default.id
  subnet_id         = data.aws_subnets.default.ids[0]
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
}

# Build the database from the rds module.
# It is told to allow traffic from the EC2 module's security group.
module "rds" {
  source = "../../modules/rds"

  environment           = var.environment
  db_instance_class     = var.db_instance_class
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  vpc_id                = data.aws_vpc.default.id
  subnet_ids            = data.aws_subnets.default.ids
  app_security_group_id = module.ec2.app_security_group_id
}

output "instance_public_ip" {
  value = module.ec2.public_ip
}

output "database_endpoint" {
  value = module.rds.endpoint
}
