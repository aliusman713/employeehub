# EmployeeHub — Cloud-Native Employee Management Platform

A production-oriented employee management application built to demonstrate modern **Cloud, DevOps, Infrastructure as Code, CI/CD, containerization, security, and AWS operations** practices.

The application consists of a React frontend, Node.js/Express backend, and PostgreSQL database, deployed on AWS using ECS Fargate, Application Load Balancer, Amazon RDS, Amazon ECR, Systems Manager Parameter Store, CloudWatch, Terraform, and GitHub Actions.

---

## 🚀 Project Overview

EmployeeHub is a containerized employee management application designed to demonstrate an end-to-end DevOps implementation.

### Application capabilities

* Employee listing
* Employee information display
* Department information
* Designation
* Salary
* Joining date
* REST API
* PostgreSQL persistence
* Health checks

### DevOps capabilities demonstrated

* Docker containerization
* AWS ECS Fargate
* Amazon ECR
* Application Load Balancer
* Amazon RDS PostgreSQL
* AWS Systems Manager Parameter Store
* CloudWatch Logs
* Terraform Infrastructure as Code
* GitHub Actions CI/CD
* GitHub OIDC federation
* Gitleaks secret scanning
* Trivy vulnerability scanning
* Immutable container image tagging
* Automated ECS deployments
* Infrastructure drift/change validation

---

# 🏗️ Architecture

```text
                         Internet
                            │
                            ▼
                 ┌─────────────────────┐
                 │   Application LB    │
                 │      Public         │
                 └──────────┬──────────┘
                            │
                 ┌──────────┴──────────┐
                 │                     │
              /api/*                  /*
                 │                     │
                 ▼                     ▼
       ┌─────────────────┐   ┌─────────────────┐
       │  ECS Fargate    │   │  ECS Fargate    │
       │    Backend      │   │   Frontend      │
       │ Node.js/Express │   │ React + NGINX   │
       │      :5000      │   │       :80       │
       └────────┬────────┘   └─────────────────┘
                │
                │ PostgreSQL
                ▼
       ┌─────────────────────┐
       │     Amazon RDS      │
       │     PostgreSQL      │
       │       :5432         │
       │     Private DB      │
       └─────────────────────┘


          Private ECS Subnets
                  │
                  │ outbound
                  ▼
             NAT Gateway
                  │
                  ▼
          Internet Gateway
```

### Network architecture

The environment follows a basic three-tier design:

```text
Public Subnets
    │
    ├── Application Load Balancer
    └── NAT Gateway

Private Application Subnets
    │
    ├── ECS Frontend
    └── ECS Backend

Private Database Subnets
    │
    └── RDS PostgreSQL
```

ECS tasks do not receive public IP addresses.

The Application Load Balancer is the public entry point to the application.

---

# ☁️ AWS Services

| Service                   | Purpose                              |
| ------------------------- | ------------------------------------ |
| Amazon VPC                | Network isolation                    |
| Public Subnets            | ALB and NAT Gateway                  |
| Private Subnets           | ECS workloads                        |
| Amazon ECS                | Container orchestration              |
| AWS Fargate               | Serverless container compute         |
| Amazon ECR                | Container image registry             |
| Application Load Balancer | Application traffic routing          |
| Amazon RDS                | PostgreSQL database                  |
| AWS SSM Parameter Store   | Secret storage                       |
| CloudWatch Logs           | Centralized logging                  |
| IAM                       | Access control                       |
| GitHub OIDC               | Keyless GitHub → AWS authentication  |
| NAT Gateway               | Private subnet outbound connectivity |
| Internet Gateway          | Internet connectivity                |

---

# 🧰 Technology Stack

## Frontend

* React
* Vite
* Axios
* NGINX
* Node.js

## Backend

* Node.js
* Express
* PostgreSQL
* `pg`
* REST API

## DevOps

* Docker
* Docker Compose
* Git
* GitHub Actions
* Terraform
* AWS ECS
* AWS ECR

## Security

* GitHub OIDC
* IAM
* AWS Systems Manager Parameter Store
* Gitleaks
* Trivy
* ECR image scanning
* Private ECS tasks
* Private RDS

## Monitoring

* Amazon CloudWatch Logs
* ECS health checks
* ALB target health checks
* Application health endpoint

---

# 📁 Repository Structure

```text
employeehub/
│
├── application/
│   │
│   ├── backend/
│   │   ├── src/
│   │   │   ├── db.js
│   │   │   ├── routes/
│   │   │   └── server.js
│   │   ├── Dockerfile
│   │   ├── package.json
│   │   └── package-lock.json
│   │
│   ├── frontend/
│   │   ├── src/
│   │   ├── public/
│   │   ├── Dockerfile
│   │   ├── nginx/
│   │   ├── package.json
│   │   └── package-lock.json
│   │
│   └── database/
│       └── init.sql
│
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── networking.tf
│   ├── security-groups.tf
│   ├── ecs-cluster.tf
│   ├── ecs-services.tf
│   ├── ecs-task-definitions.tf
│   ├── alb.tf
│   ├── rds.tf
│   ├── ecr.tf
│   ├── ssm.tf
│   └── outputs.tf
│
├── .github/
│   └── workflows/
│       ├── ecr.yml
│       └── security.yml
│
├── docker-compose.yml
├── .gitignore
├── .yamllint
└── README.md
```

> AWS evidence screenshots are intentionally kept locally and should not be committed to the public repository.

---

# 🐳 Local Development

## Prerequisites

Install:

* Git
* Docker
* Docker Compose
* Node.js
* npm

Verify:

```bash
git --version
docker --version
docker compose version
node --version
npm --version
```

---

## Start the application locally

From the project root:

```bash
docker compose up -d --build
```

Verify containers:

```bash
docker compose ps
```

Expected components:

```text
employeehub-frontend
employeehub-backend
employeehub-postgres
```

---

## Test the backend

```bash
curl http://localhost:5000/health
```

Test employees:

```bash
curl http://localhost:5000/api/employees
```

The API should return employee records from PostgreSQL.

---

## Stop the application

```bash
docker compose down
```

To remove local database storage as well:

```bash
docker compose down -v
```

---

# 🗄️ Database

EmployeeHub uses PostgreSQL.

### Main tables

```text
departments
employees
users
```

The employee relationship is:

```text
departments
     │
     │ department_id
     ▼
employees
```

The database schema is defined in:

```text
application/database/init.sql
```

For the AWS deployment, database initialization was performed using a temporary ECS migration task.

### Production improvement

A future enhancement is to replace the initial SQL bootstrap process with a formal database migration framework such as:

* node-pg-migrate
* Flyway
* Liquibase

This would provide versioned and repeatable database migrations across environments.

---

# 🔌 Backend API

### Health check

```http
GET /health
```

### Employee API

```http
GET /api/employees
```

Example:

```bash
curl http://<ALB-DNS>/api/employees
```

The backend runs on:

```text
Port: 5000
```

---

# 🐳 Containerization

Both application components are containerized independently.

## Backend

```text
Node.js
   │
   ▼
Docker
   │
   ▼
ECS Fargate :5000
```

The backend Docker image uses a production Node.js runtime and installs only production dependencies.

## Frontend

```text
React
   │
   ▼
Vite build
   │
   ▼
NGINX
   │
   ▼
ECS Fargate :80
```

The production frontend uses NGINX to serve the compiled React application.

---

# 📦 Amazon ECR

Two ECR repositories are used:

```text
employeehub-backend
employeehub-frontend
```

Container images are tagged using the Git commit SHA.

Example:

```text
182cd942e0d5
```

This provides immutable deployment traceability:

```text
Git Commit
    │
    ▼
Docker Image
    │
    ▼
ECR
    │
    ▼
ECS Task Definition
    │
    ▼
Production Deployment
```

Instead of relying exclusively on `latest`, CI/CD generates commit-based image tags.

---

# 🚀 CI/CD Pipeline

GitHub Actions provides the automated deployment pipeline.

```text
Developer
    │
    ▼
Git Push
    │
    ▼
GitHub
    │
    ▼
GitHub Actions
    │
    ├── Checkout
    ├── Security checks
    ├── Docker build
    ├── Image scanning
    ├── AWS authentication
    ├── ECR login
    ├── Push backend image
    ├── Push frontend image
    ├── Register ECS task definitions
    ├── Update ECS services
    ├── Wait for deployment stability
    └── Verify deployment
             │
             ▼
       ECS Fargate
```

---

# 🔐 GitHub OIDC

The pipeline does not require long-lived AWS access keys stored in GitHub.

GitHub Actions authenticates to AWS using:

```text
GitHub Actions
      │
      │ OIDC token
      ▼
AWS STS
      │
      │ AssumeRoleWithWebIdentity
      ▼
EmployeeHubGitHubActionsECRRole
```

The IAM trust policy restricts access to:

```text
aliusman713/employeehub
```

and the:

```text
main
```

branch.

This follows the principle of minimizing long-lived credentials.

---

# 🔑 Secrets Management

Sensitive values are stored in AWS Systems Manager Parameter Store.

Parameters include:

```text
/employeehub/dev/db-password
/employeehub/dev/jwt-secret
```

They use:

```text
SecureString
```

The values are not stored in GitHub source code.

The ECS task definition retrieves the parameters through the ECS execution role.

---

# 🛡️ Security Pipeline

Security checks are integrated into GitHub Actions.

### Gitleaks

Detects accidentally committed secrets.

```text
Source Code
     │
     ▼
Gitleaks
     │
     ├── PASS → Continue
     └── FAIL → Stop pipeline
```

### Trivy filesystem scanning

Scans the project filesystem for vulnerabilities and misconfigurations.

### Trivy container scanning

Both backend and frontend images are scanned.

```text
Docker Build
     │
     ▼
Trivy Image Scan
     │
     ├── PASS → Push to ECR
     └── FAIL → Pipeline failure
```

### ECR scanning

ECR also performs image scanning when images are pushed.

---

# 🩺 Health Checks

The backend exposes:

```text
/health
```

The ALB uses health checks to determine whether ECS tasks are healthy.

Traffic flow:

```text
ALB
 │
 │ Health Check
 ▼
ECS Backend
 │
 ▼
/health
 │
 └── HTTP 200
```

Unhealthy tasks can therefore be removed from service by the load balancer.

---

# 📊 Monitoring

Application logs are sent to CloudWatch.

Backend log group:

```text
/ecs/employeehub-dev/backend
```

CloudWatch provides centralized visibility into:

* Application startup
* Database connectivity
* API requests
* Errors
* ECS task behavior

Example successful startup:

```text
Connected to PostgreSQL
```

---

# 🏗️ Infrastructure as Code

AWS infrastructure is managed using Terraform.

Terraform provisions resources including:

* VPC
* Subnets
* Internet Gateway
* NAT Gateway
* Route tables
* Security groups
* ALB
* Target groups
* ECS cluster
* ECS services
* ECS task definitions
* ECR repositories
* RDS PostgreSQL
* SSM parameters
* IAM resources

Validate infrastructure:

```bash
terraform -chdir=terraform plan
```

The final validated state:

```text
Plan: 0 to add, 0 to change, 0 to destroy.
```

---

# 🔄 Terraform and CI/CD Ownership

Terraform manages the infrastructure lifecycle, while GitHub Actions manages application deployments.

This separation prevents Terraform from continuously attempting to roll ECS services back to an older task definition.

The ECS services therefore use:

```hcl
lifecycle {
  ignore_changes = [
    task_definition
  ]
}
```

This allows GitHub Actions to register new ECS task-definition revisions and deploy them independently.

---

# 🌐 Traffic Routing

The Application Load Balancer uses path-based routing.

```text
http://ALB/
       │
       ▼
Frontend ECS

http://ALB/api/
       │
       ▼
Backend ECS
```

The frontend itself does not proxy `/api` traffic through a Docker-internal hostname.

This is important because ECS services are dynamically addressed and the frontend container should not depend on a static Docker Compose service name such as:

```text
backend
```

---

# 🧪 Validation

Application validation was performed at multiple layers.

### Local

```bash
curl http://localhost:5000/health
curl http://localhost:5000/api/employees
```

### AWS ALB

```bash
ALB_URL=$(terraform -chdir=terraform output -raw alb_url)

curl -i "$ALB_URL/api/employees"
```

### Infrastructure

```bash
terraform -chdir=terraform plan
```

Expected:

```text
0 to add
0 to change
0 to destroy
```

### ECS

Validated:

* ECS service running
* Tasks healthy
* ALB target groups healthy
* CloudWatch logs available

---

# 🐛 Production Troubleshooting Lessons

This project intentionally demonstrates several real-world DevOps troubleshooting scenarios.

## 1. ECS frontend task failed to start

### Problem

NGINX attempted to resolve:

```text
backend:5000
```

The hostname existed in Docker Compose but not in the ECS networking model.

### Error

```text
host not found in upstream "backend"
```

### Resolution

Removed the Docker Compose-specific NGINX proxy configuration.

The ALB now performs routing:

```text
/api/* → Backend ECS
/*     → Frontend ECS
```

---

## 2. Backend could not connect to RDS

### Problem

PostgreSQL rejected the connection with:

```text
no pg_hba.conf entry
```

### Root cause

RDS PostgreSQL required SSL for the connection.

### Resolution

Production PostgreSQL connections use SSL:

```javascript
ssl:
  process.env.NODE_ENV === "production"
    ? { rejectUnauthorized: false }
    : false
```

Local development remains non-SSL.

---

## 3. Database schema missing

After connectivity was fixed, the backend reported:

```text
relation "employees" does not exist
```

This confirmed:

```text
Backend → RDS
```

connectivity was working, but the database had not been initialized.

A temporary ECS migration task was used to execute the schema and seed data against RDS.

### Long-term improvement

Implement version-controlled database migrations.

---

## 4. Terraform attempted to revert ECS deployments

Terraform initially detected a difference between its task definition revision and the revision deployed by GitHub Actions.

The solution was to explicitly separate infrastructure ownership from application deployment:

```hcl
lifecycle {
  ignore_changes = [
    task_definition
  ]
}
```

Final Terraform plan:

```text
Plan: 0 to add, 0 to change, 0 to destroy.
```

---

# 💰 Cost Optimization

The project was designed with development costs in mind.

Important considerations include:

* Use small Fargate task sizes
* Use a small RDS instance
* Avoid unnecessary NAT Gateway usage
* Avoid unnecessary Multi-AZ resources in development
* Remove unused AWS resources
* Destroy the development environment when the project is no longer required
* Monitor AWS Billing regularly

The development environment is intentionally not designed as a highly available production environment.

For a real production implementation, availability and resilience requirements would determine:

* Multiple AZs
* Multiple ECS tasks
* RDS Multi-AZ
* NAT Gateway redundancy
* Autoscaling
* Enhanced monitoring
* Backup retention

---

# 🔒 Production Hardening Opportunities

Future improvements could include:

* AWS WAF
* HTTPS with ACM
* Route 53 custom domain
* ECS Service Auto Scaling
* RDS Multi-AZ
* RDS automated backups
* KMS customer-managed keys
* Secrets Manager
* Formal database migrations
* Prometheus/Grafana
* Distributed tracing
* OpenTelemetry
* Argo CD / GitOps
* Blue/green deployment
* Canary deployments
* DORA metrics
* SAST/DAST integration
* SBOM generation
* Container signing
* OPA/Conftest policy checks

---

# 📈 Future CI/CD Enhancement

The current pipeline establishes a strong CI/CD foundation.

A future production pipeline could evolve into:

```text
Developer
   │
   ▼
Pull Request
   │
   ├── Unit Tests
   ├── Lint
   ├── SAST
   ├── Secret Scan
   ├── Dependency Scan
   ├── IaC Scan
   └── Docker Scan
           │
           ▼
       Build Image
           │
           ▼
       SBOM / Sign
           │
           ▼
          ECR
           │
           ▼
       Deployment
           │
           ▼
       ECS / EKS
           │
           ▼
      Monitoring
           │
           ▼
      DORA Metrics
```

---

# 📸 Project Evidence

The project includes locally captured evidence demonstrating the AWS deployment.

```text
evidence/
├── 01-employeehub-application.png
├── 02-api-success.png
├── 02-api-success.txt
├── 03-github-ci.png
├── 04-security-scans.png
├── 05-deployment-success.png
├── 06-ecr.png
├── 07-ecs.png
├── 08-alb-target-groups.png
├── 09-rds.png
├── 10-ssm.png
├── 11-cloudwatch.png
├── 12-terraform-plan.png
├── 13-github-oidc.png
└── 14-vpc-network.png
```

These files should remain local and should not be committed to the public repository if they contain AWS account information or other sensitive infrastructure details.

---

# 🎯 Interview Talking Points

This project can be explained in an interview as an end-to-end DevOps implementation.

### Architecture

> "I designed EmployeeHub using a three-tier AWS architecture. The Application Load Balancer is public, while ECS Fargate workloads and RDS PostgreSQL remain in private subnets."

### CI/CD

> "GitHub Actions builds and scans the application images, authenticates to AWS through OIDC, pushes immutable commit-based images to ECR, registers new ECS task definitions, updates the ECS services, waits for deployment stability, and verifies the deployment."

### Security

> "I avoided long-lived AWS credentials in GitHub by using GitHub OIDC. Application secrets are stored in SSM Parameter Store as SecureString parameters, and the pipeline performs Gitleaks and Trivy scanning."

### Terraform

> "Terraform manages the AWS infrastructure, while GitHub Actions owns application deployment. I used Terraform lifecycle ignore_changes for ECS task definitions so Terraform doesn't revert application deployments made by CI/CD."

### Troubleshooting

> "During deployment I encountered an NGINX DNS issue because the production container still referenced the Docker Compose hostname `backend`. I removed that dependency and moved API routing to the Application Load Balancer."

### Database

> "The backend initially failed against RDS because production PostgreSQL required SSL. After enabling SSL, the application connected successfully, and the next error showed that the database schema was missing. I then executed the initialization SQL through a temporary ECS migration task."

---

# 🏆 Key DevOps Skills Demonstrated

```text
AWS
├── VPC
├── IAM
├── ECS
├── Fargate
├── ECR
├── ALB
├── RDS
├── SSM
├── CloudWatch
└── NAT Gateway

DevOps
├── Git
├── GitHub Actions
├── CI/CD
├── Docker
├── Terraform
├── OIDC
└── Automation

Security
├── Gitleaks
├── Trivy
├── IAM least privilege
├── OIDC
├── SecureString
└── Private networking

Application
├── React
├── Node.js
├── Express
├── PostgreSQL
└── NGINX
```

---

# 👨‍💻 Author

Built as a hands-on Cloud & DevOps portfolio project demonstrating practical experience with AWS, Terraform, Docker, CI/CD, container orchestration, security, networking, and troubleshooting.

---

## ⭐ Project Goal

The objective of EmployeeHub is not simply to deploy an application.

It demonstrates the complete DevOps lifecycle:

```text
Code
  ↓
Git
  ↓
CI
  ↓
Security
  ↓
Container Build
  ↓
ECR
  ↓
Infrastructure
  ↓
ECS
  ↓
ALB
  ↓
RDS
  ↓
Monitoring
  ↓
Validation
  ↓
Continuous Improvement
```

This project is designed to demonstrate how application development, cloud infrastructure, security, automation, deployment, and operations can be integrated into a single reproducible workflow.
