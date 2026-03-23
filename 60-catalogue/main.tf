resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  instance_type = var.instance_type
  subnet_id     = local.private_subnet_ids
  vpc_security_group_ids = [local.catalogue_sg_id]
 #iam_instance_profile = aws_iam_instance_profile.mongodb.name

  tags = merge(
      
    {
        Name = "${var.project}-${var.environment}-mongodb"
    },
    local.common_tags
  )
}

resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id
   ]

connection {
      type        = "ssh"
      user        = "ec2-user" # or "ubuntu", depending on the AMI
      password    =  "DevOps321"
      host        = aws_instance.catalogue.private_ip
    }

    provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }


  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh catalogue ${var.environment}"
    ]
  }
}

