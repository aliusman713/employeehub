resource "aws_lb" "employeehub" {
  name               = "employeehub-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = aws_subnet.public[*].id

  enable_deletion_protection = false

  tags = {
    Name = "employeehub-${var.environment}-alb"
  }
}
resource "aws_lb_target_group" "frontend" {
  name        = "employeehub-${var.environment}-frontend"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.employeehub.id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

  tags = {
    Name = "employeehub-${var.environment}-frontend-tg"
  }
}

resource "aws_lb_target_group" "backend" {
  name        = "employeehub-${var.environment}-backend"
  port        = 5000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.employeehub.id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/health"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name = "employeehub-${var.environment}-backend-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.employeehub.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}
resource "aws_lb_listener_rule" "backend" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  condition {
    path_pattern {
      values = [
        "/api",
        "/api/*"
      ]
    }
  }
}
