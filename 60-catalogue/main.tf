resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  instance_type = var.instance_type
  subnet_id     = local.private_subnet_ids
  vpc_security_group_ids = [local.catalogue_sg_id]
 #iam_instance_profile = aws_iam_instance_profile.mongodb.name

  tags = merge(
      
    {
        Name = "${var.project}-${var.environment}-catalogue"
    },
    local.common_tags
  )
}

resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id ]

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

resource "aws_ec2_instance_state" "catalogue" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
  depends_on = [terraform_data.catalogue]
}

resource "aws_ami_from_instance" "catalogue" {
  name               = "${var.project}-${var.environment}-catalogue-ami"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [aws_ec2_instance_state.catalogue]
}


resource "aws_lb_target_group" "catalogue" {
  name        = "${var.project}-${var.environment}-catalogue-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = local.vpc_id
  deregistration_delay = 30

  health_check {
  healthy_threshold = 2
  interval = 10
  unhealthy_threshold = 2
  matcher = "200-299"
  path = "/health"
  port = "8080"
  protocol = "HTTP"
  timeout = 5

  }
 
}

resource "aws_launch_template" "catalogue" {
        name = "${var.project}-${var.environment}-catalogue"
        image_id = "aws_ami_from_instance.catalogue.id"
        # once autoscaling sees less traffic it will terminate the instance and when it sees more traffic it will launch the instance using this launch template and it will use the AMI which we created from the instance which we launched and configured as per our requirement.
        instance_initiated_shutdown_behavior = "terminate"
        instance_type = "var.instance_type"
        vpc_security_group_ids = [local.catalogue_sg_id]
        update_default_version = true
        tag_specifications {
            resource_type = "instance"
        # tags for instance which will be launched using this launch template
            tags = merge(
                
                {
                    Name = "${var.project}-${var.environment}-catalogue"
                },
                local.common_tags

            )
        }
        # tags for launch template is different from tags for instance. when we create launch template we can give tags to the launch template and when we launch the instance using that launch template we can give tags to the instance. here we are giving same tags to both launch template and instance but we can give different tags to both.
        tags = merge(
                
                {
                    Name = "${var.project}-${var.environment}-catalogue"
                },
                local.common_tags

    )

}

resource "aws_autoscaling_group" "catalogue" {
        name                      = "${var.project}-${var.environment}-catalogue"
        max_size                  = 5
        min_size                  = 1
        health_check_grace_period = 120
        health_check_type         = "ELB"
        desired_capacity          = 1
        force_delete              = false

        launch_template {
            id      = aws_launch_template.catalogue.id
            version = "$Latest"
        }

        
        vpc_zone_identifier       = [local.private_subnet_ids]

        target_group_arns = aws_lb_target_group.catalogue.arn

        instance_refresh {
            strategy = "Rolling"
            preferences {
            min_healthy_percentage = 50
            }
            triggers = ["launch_template"]
        }

        dynamic "tag" {
            for_each = merge(
                
                {
                    Name = "${var.project}-${var.environment}-catalogue"
                },
                local.common_tags

            )
            content {
            key                 = tag.key
            value               = tag.value
            propagate_at_launch = true
            }
        }

        # within 15 mins auto scaling should be successfull 
        timeouts {
            delete = "15m"
        }

}

resource "aws_autoscaling_policy" "catalogue" {
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
  name                   = "${var.project}-${var.environment}-catalogue"
 policy_type            = "TargetTrackingScaling"
    target_tracking_configuration {
        predefined_metric_specification {
        predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = 70.0
    }

}

resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = local.backend_alb_listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.backend-alb-${var.environment}.${var.domain}"]
    }
  }
}

resource "terraform_data" "catalogue_terminate" {
  triggers_replace = [ aws_instance.catalogue.id ]
  depends_on = [ aws_autoscaling_policy.catalogue ]

   provisioner "local-exec" {
    command = "aws ec2 terminate-instances ${aws_instance.catalogue.id}"
  }

  
}