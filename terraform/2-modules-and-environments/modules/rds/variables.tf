# modules/rds/variables.tf

variable "environment" {
  description = "Environment name (dev or qa)"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance size"
  type        = string
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_username" {
  description = "Database master username"
  type        = string
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC to place the database in"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for the DB subnet group (need at least two AZs)"
  type        = list(string)
}

variable "app_security_group_id" {
  description = "Security group of the app that is allowed to reach the database"
  type        = string
}
