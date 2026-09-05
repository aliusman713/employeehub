output "vpc_id" {
  description = "EmployeeHub VPC ID."
  value       = aws_vpc.employeehub.id
}

output "public_subnet_ids" {
  description = "EmployeeHub public subnet IDs."
  value       = aws_subnet.public[*].id
}

output "private_app_subnet_ids" {
  description = "EmployeeHub private application subnet IDs."
  value       = aws_subnet.private_app[*].id
}

output "availability_zones" {
  description = "Availability zones used by EmployeeHub."
  value       = data.aws_availability_zones.available.names
}
output "private_db_subnet_ids" {
  description = "EmployeeHub private database subnet IDs."
  value       = aws_subnet.private_db[*].id
}

output "rds_endpoint" {
  description = "EmployeeHub RDS endpoint."
  value       = aws_db_instance.employeehub.address
}

output "rds_port" {
  description = "EmployeeHub RDS PostgreSQL port."
  value       = aws_db_instance.employeehub.port
}

output "rds_security_group_id" {
  description = "EmployeeHub RDS security group ID."
  value       = aws_security_group.rds.id
}

output "app_security_group_id" {
  description = "EmployeeHub application security group ID."
  value       = aws_security_group.app.id
}

output "alb_security_group_id" {
  description = "EmployeeHub ALB security group ID."
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "EmployeeHub ECS security group ID."
  value       = aws_security_group.ecs.id
}

output "alb_dns_name" {
  description = "EmployeeHub Application Load Balancer DNS name."
  value       = aws_lb.employeehub.dns_name
}

output "alb_url" {
  description = "EmployeeHub Application Load Balancer URL."
  value       = "http://${aws_lb.employeehub.dns_name}"
}
