data "aws_ssm_parameter" "bastion_sg_id" {
  name = "/${var.project}/${var.environment}/bastion_sg_id"
}

data "aws_ssm_parameter" "mongodb_sg_id" {
  name = "/${var.project}/${var.environment}/mongodb_sg_id"
}

data "aws_ssm_parameter" "redis_sg_id" {
  name = "/${var.project}/${var.environment}/redis_sg_id"
}

data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project}/${var.environment}/mysql_sg_id"
}

data "aws_ssm_parameter" "rabbitmq_sg_id" {
  name = "/${var.project}/${var.environment}/rabbitmq_sg_id"
}
    
data "aws_ssm_parameter" "catalogue_sg_id" {
  name = "/${var.project}/${var.environment}/catalogue_sg_id"
}

data "aws_ssm_parameter" "user_sg_id" {
  name = "/${var.project}/${var.environment}/user_sg_id"
}

data "aws_ssm_parameter" "backend-alb_sg_id" {
  name = "/${var.project}/${var.environment}/backend-alb_sg_id"
}

data "aws_ssm_parameter" "frontend_alb_sg_id" {
  name = "/${var.project}/${var.environment}/frontend-alb_sg_id"
}