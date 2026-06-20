# environments/dev/terraform.tfvars

environment       = "dev"
instance_type     = "t3.micro"
db_instance_class = "db.t3.micro"

# Replace with your own IP (find it at https://whatismyip.com)
allowed_ssh_cidrs = ["87.141.54.39/32"]
