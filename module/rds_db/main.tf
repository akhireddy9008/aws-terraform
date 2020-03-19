#Randam Password
resource "random_password" "rds-password" {
  length  = 16
  special = false

  keepers = {
    keeper_id = "${var.keeper}"
  }
}

#RDS DB 
resource "aws_db_instance" "rds_prod" {
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "11.2"
  instance_class    = "db.t2.micro"
  identifier        = var.rds_name
  username          = var.rds_username
  password          = "{random_password.rds-password}"
  lifecycle {
    ignore_changes = ["password"]
  }
  parameter_group_name    = aws_db_parameter_group.db_pg.name
  publicly_accessible     = "false"
  db_subnet_group_name    = aws_db_subnet_group.db_sub_group.id
  vpc_security_group_ids  = [aws_security_group.db_sg.id, ]
  multi_az                = "false"
  backup_retention_period = "10"
  backup_window           = "04:46-05:16" #UTC Time
  deletion_protection     = "false"
  apply_immediately       = "false"
  skip_final_snapshot     = "true"

  tags = {
    Name        = var.rds_name
    Environment = var.environment
  }
}

# DB Subnet Group 
resource "aws_db_subnet_group" "db_sub_group" {
  name       = var.rds_db_sub_group_name
  subnet_ids = var.rds_db_sub_group_ids
  lifecycle { ignore_changes = all }

  tags = {
    Name        = var.rds_db_sub_group_name
    Environment = var.environment
  }
}

#DB Parameter group
resource "aws_db_parameter_group" "db_pg" {
  name   = "rds-pg-postgres11-${var.environment}"
  family = "postgres11"
}

#DB Security Group
resource "aws_security_group" "db_sg" {
  name   = "${var.rds_db_sg}-${var.environment}"
  vpc_id = var.rds_db_sg_vpc_id
  lifecycle {
    ignore_changes        = [vpc_id, ]
    create_before_destroy = true
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.rds_db_sg_ingres_cidr, ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}