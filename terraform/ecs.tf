resource "aws_ecs_cluster" "employeehub" {
  name = "employeehub-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "employeehub-${var.environment}-ecs"
  }
}
