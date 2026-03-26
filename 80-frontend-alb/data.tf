data "aws_ssm_parameter" "public_alb_sg_id" {
  name = "/${var.project}/${var.environment}/public-alb_sg_id"
  
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}/${var.environment}/public-subnet-ids"
}