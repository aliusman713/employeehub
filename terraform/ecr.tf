resource "aws_ecr_repository" "backend" {
  name                 = "employeehub-backend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "employeehub-${var.environment}-backend-ecr"
  }
}

resource "aws_ecr_repository" "frontend" {
  name                 = "employeehub-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "employeehub-${var.environment}-frontend-ecr"
  }
}
