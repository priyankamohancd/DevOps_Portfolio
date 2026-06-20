# environments/dev/variables.tf

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "environment" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_name" {
  type    = string
  default = "appdb"
}

variable "db_username" {
  type    = string
  default = "appadmin"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "allowed_ssh_cidrs" {
  type = list(string)
}
