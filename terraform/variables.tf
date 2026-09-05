variable "aws_region" {
  description = "AWS region where EmployeeHub infrastructure will be deployed."
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
variable "db_username" {
  description = "RDS PostgreSQL administrator username."
  type        = string
  default     = "employeehubadmin"
}

variable "db_password" {
  description = "RDS PostgreSQL administrator password."
  type        = string
  sensitive   = true
}
variable "jwt_secret" {
  description = "JWT signing secret for EmployeeHub."
  type        = string
  sensitive   = true
}
