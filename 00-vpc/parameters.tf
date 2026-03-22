resource "aws_ssm_parameter" "vpc_id" {
  name        = "/${var.project}/${var.environment}/vpc-id"
  description = "vpc id for ${var.project} project in ${var.environment} environment"
  type        = "SecureString"
  value       = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name        = "/${var.project}/${var.environment}/public-subnet-ids"
  description = "Public subnet IDs for ${var.project} project in ${var.environment} environment"
  type        = "StringList"
  value       = join(",", module.vpc.public_subnet_ids)
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name        = "/${var.project}/${var.environment}/private-subnet-ids"
  description = "Private subnet IDs for ${var.project} project in ${var.environment} environment"
  type        = "StringList"
  value       = join(",", module.vpc.private_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnet_ids" {
  name        = "/${var.project}/${var.environment}/database-subnet-ids"
  description = "Database subnet IDs for ${var.project} project in ${var.environment} environment"
  type        = "StringList"
  value       = join(",", module.vpc.database_subnet_ids)
}