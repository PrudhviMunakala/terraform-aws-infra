data "aws_ami" "join_devops" {
  most_recent = true
  owners      = ["973714476881"] # Canonical's AWS Account ID

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

   filter {
    name   = "root-device-type"
    values = ["ebs"]
    }
}



data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project}/${var.environment}/public-subnet-ids"
}

data "aws_ssm_parameter" "bastion_sg_id" {
  name = "/${var.project}/${var.environment}/bastion_sg_id"
}