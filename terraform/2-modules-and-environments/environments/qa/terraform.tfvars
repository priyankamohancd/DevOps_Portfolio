# environments/qa/terraform.tfvars

environment       = "qa"
instance_type     = "t3.small"
db_instance_class = "db.t3.small"

# Replace with your own IP (find it at https://whatismyip.com)
allowed_ssh_cidrs = ["203.0.113.10/32"]
