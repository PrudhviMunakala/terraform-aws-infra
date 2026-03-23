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
      "sudo sh /tmp/bootstrap.sh catalogue dev"
    ]
  }
}

# redis instance and configuration

/* resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = var.instance_type
  subnet_id     = local.database_subnet_id
  vpc_security_group_ids = [local.redis_sg_id]
 #iam_instance_profile = aws_iam_instance_profile.redis.name

  tags = merge(
      
    {
        Name = "${var.project}-${var.environment}-redis"
    },
    local.common_tags
  )
}

resource "terraform_data" "redis" {
  triggers_replace = [
    aws_instance.redis.id
   ]

connection {
      type        = "ssh"
      user        = "ec2-user" # or "ubuntu", depending on the AMI
      password    =  "DevOps321"
      host        = aws_instance.redis.private_ip
    }

    provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }


  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh redis"
    ]
  }
}

# mysql instance and configuration

resource "aws_instance" "mysql" {
  ami           = local.ami_id
  instance_type = var.instance_type
  subnet_id     = local.database_subnet_id
  vpc_security_group_ids = [local.mysql_sg_id]
  iam_instance_profile = aws_iam_instance_profile.mysql.name

  tags = merge(
      
    {
        Name = "${var.project}-${var.environment}-mysql"
    },
    local.common_tags
  )
}

resource "terraform_data" "mysql" {
  triggers_replace = [
    aws_instance.mysql.id
   ]

connection {
      type        = "ssh"
      user        = "ec2-user" # or "ubuntu", depending on the AMI
      password    =  "DevOps321"
      host        = aws_instance.mysql.private_ip
    }

    provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }


  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql ${var.environment}"
    ]
  }
}

# rabbitmq instance and configuration

resource "aws_instance" "rabbitmq" {
  ami           = local.ami_id
  instance_type = var.instance_type
  subnet_id     = local.database_subnet_id
  vpc_security_group_ids = [local.rabbitmq_sg_id]
 #iam_instance_profile = aws_iam_instance_profile.rabbitmq.name

  tags = merge(
      
    {
        Name = "${var.project}-${var.environment}-rabbitmq"
    },
    local.common_tags
  )
}

resource "terraform_data" "rabbitmq" {
  triggers_replace = [
    aws_instance.rabbitmq.id
   ]

connection {
      type        = "ssh"
      user        = "ec2-user" # or "ubuntu", depending on the AMI
      password    =  "DevOps321"
      host        = aws_instance.rabbitmq.private_ip
    }

    provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
  }


  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh rabbitmq"
    ]
  }
}

 */