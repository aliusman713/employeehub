resource "aws_security_group" "alb" {
  name        = "employeehub-${var.environment}-alb-sg"
  description = "Security group for EmployeeHub Application Load Balancer"
  vpc_id      = aws_vpc.employeehub.id

  tags = {
    Name = "employeehub-${var.environment}-alb-sg"
  }
}

resource "aws_security_group" "ecs" {
  name        = "employeehub-${var.environment}-ecs-sg"
  description = "Security group for EmployeeHub ECS services"
  vpc_id      = aws_vpc.employeehub.id

  tags = {
    Name = "employeehub-${var.environment}-ecs-sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "ecs_frontend_from_alb" {
  security_group_id            = aws_security_group.ecs.id
  referenced_security_group_id = aws_security_group.alb.id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Allow frontend traffic from ALB"
}
resource "aws_vpc_security_group_ingress_rule" "ecs_backend_from_frontend" {
  security_group_id            = aws_security_group.ecs.id
  referenced_security_group_id = aws_security_group.ecs.id

  from_port   = 5000
  to_port     = 5000
  ip_protocol = "tcp"

  description = "Allow backend traffic within ECS security group"
}
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  description = "Allow HTTP traffic from Internet"
}
resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound traffic from ALB"
}

resource "aws_vpc_security_group_egress_rule" "ecs_all" {
  security_group_id = aws_security_group.ecs.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound traffic from ECS tasks"
}

resource "aws_vpc_security_group_ingress_rule" "ecs_backend_from_alb" {
  security_group_id            = aws_security_group.ecs.id
  referenced_security_group_id = aws_security_group.alb.id

  from_port   = 5000
  to_port     = 5000
  ip_protocol = "tcp"

  description = "Allow backend traffic from ALB"
}
