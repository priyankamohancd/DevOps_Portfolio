# modules/ec2/outputs.tf

output "public_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.app.public_ip
}

output "app_security_group_id" {
  description = "Security group ID. Pass this to the RDS module so the DB can allow the app in."
  value       = aws_security_group.ec2.id
}
