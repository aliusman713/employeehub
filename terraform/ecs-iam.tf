resource "aws_iam_role" "ecs_task_execution" {
  name = "employeehub-${var.environment}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "employeehub-${var.environment}-ecs-task-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role = aws_iam_role.ecs_task_execution.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution IAM role."
  value       = aws_iam_role.ecs_task_execution.arn
}
resource "aws_iam_role_policy" "ecs_secrets_access" {
  name = "employeehub-${var.environment}-ecs-secrets-access"
  role = aws_iam_role.ecs_task_execution.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ReadEmployeeHubSecrets"
        Effect = "Allow"

        Action = [
          "ssm:GetParameters"
        ]

        Resource = [
          aws_ssm_parameter.db_password.arn,
          aws_ssm_parameter.jwt_secret.arn
        ]
      }
    ]
  })
}
