resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/employeehub-${var.environment}/backend"
  retention_in_days = 7

  tags = {
    Name = "employeehub-${var.environment}-backend-logs"
  }
}

resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/employeehub-${var.environment}/frontend"
  retention_in_days = 7

  tags = {
    Name = "employeehub-${var.environment}-frontend-logs"
  }
}
