# modules/rds/outputs.tf

output "endpoint" {
  description = "Database connection endpoint"
  value       = aws_db_instance.db.endpoint
}
