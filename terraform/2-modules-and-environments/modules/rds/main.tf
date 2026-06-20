# modules/rds/main.tf

resource "aws_security_group" "db" {
  name        = "${var.environment}-db-sg"
  description = "Allow database access from the app only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "DB from app"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.app_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.environment}-db-sg" }
}

resource "aws_db_subnet_group" "db" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "db" {
  identifier             = "${var.environment}-db"
  engine                 = "postgres"
  engine_version         = "18.4"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  storage_encrypted      = true

  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  port                   = 5432

  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids  = [aws_security_group.db.id]
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = { Name = "${var.environment}-db" }
}
