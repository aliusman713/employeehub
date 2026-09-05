resource "aws_ssm_parameter" "db_password" {
  name        = "/employeehub/${var.environment}/db-password"
  description = "EmployeeHub RDS PostgreSQL password"
  type        = "SecureString"
  value       = var.db_password
  tier        = "Standard"

  tags = {
    Name = "employeehub-${var.environment}-db-password"
  }
}

resource "aws_ssm_parameter" "jwt_secret" {
  name        = "/employeehub/${var.environment}/jwt-secret"
  description = "EmployeeHub JWT signing secret"
  type        = "SecureString"
  value       = var.jwt_secret
  tier        = "Standard"

  tags = {
    Name = "employeehub-${var.environment}-jwt-secret"
  }
}
