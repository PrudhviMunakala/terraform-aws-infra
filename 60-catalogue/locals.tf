locals {
  ami_id = data.aws_ami.join_devops.id
  catalogue_sg_id = data.aws_ssm_parameter.catalogue_sg_id.value
  private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]

  common_tags ={
        project = var.project
        environment = var.environment
        terraform = true
    }
}