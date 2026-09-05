resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.employeehub.id

  tags = {
    Name = "employeehub-${var.environment}-private-db-rt"
  }
}

resource "aws_route_table_association" "private_db" {
  count = 2

  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private_db.id
}

resource "aws_db_subnet_group" "employeehub" {
  name       = "employeehub-${var.environment}-db-subnet-group"
  subnet_ids = aws_subnet.private_db[*].id

  tags = {
    Name = "employeehub-${var.environment}-db-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name        = "employeehub-${var.environment}-rds-sg"
  description = "Security group for EmployeeHub RDS PostgreSQL"
  vpc_id      = aws_vpc.employeehub.id

  tags = {
    Name = "employeehub-${var.environment}-rds-sg"
  }
}

resource "aws_security_group" "app" {
  name        = "employeehub-${var.environment}-app-sg"
  description = "Security group for EmployeeHub application workloads"
  vpc_id      = aws_vpc.employeehub.id

  tags = {
    Name = "employeehub-${var.environment}-app-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_from_app" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.ecs.id

  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"

  description = "Allow PostgreSQL traffic from EmployeeHub ECS services"
}

resource "aws_db_instance" "employeehub" {
  identifier = "employeehub-${var.environment}-postgres"

  engine         = "postgres"
  engine_version = "17"

  instance_class        = "db.t4g.micro"
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = "employeehub"
  username = var.db_username
  password = var.db_password
  port     = 5432

  db_subnet_group_name   = aws_db_subnet_group.employeehub.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = false

  backup_retention_period = 0
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  multi_az            = false
  deletion_protection = false
  skip_final_snapshot = true

  tags = {
    Name = "employeehub-${var.environment}-postgres"
  }
}
