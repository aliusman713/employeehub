resource "aws_ecs_service" "backend" {
  name            = "employeehub-${var.environment}-backend"
  cluster         = aws_ecs_cluster.employeehub.id
  task_definition = aws_ecs_task_definition.backend.arn

  desired_count = 1
  launch_type   = "FARGATE"

  platform_version = "LATEST"

  network_configuration {
    subnets = aws_subnet.private_app[*].id

    security_groups = [
      aws_security_group.ecs.id
    ]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "backend"
    container_port   = 5000
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  depends_on = [
    aws_lb_listener.http,
    aws_lb_listener_rule.backend
  ]

  tags = {
    Name = "employeehub-${var.environment}-backend-service"
  }
}
resource "aws_ecs_service" "frontend" {
  name            = "employeehub-${var.environment}-frontend"
  cluster         = aws_ecs_cluster.employeehub.id
  task_definition = aws_ecs_task_definition.frontend.arn

  desired_count = 1
  launch_type   = "FARGATE"

  platform_version = "LATEST"

  network_configuration {
    subnets = aws_subnet.private_app[*].id

    security_groups = [
      aws_security_group.ecs.id
    ]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend.arn
    container_name   = "frontend"
    container_port   = 80
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  depends_on = [
    aws_lb_listener.http
  ]

  tags = {
    Name = "employeehub-${var.environment}-frontend-service"
  }
}
