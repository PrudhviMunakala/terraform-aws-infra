resource "aws_iam_role" "mysql" {
  name = "RoboshopDevMysqlRole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(
      
    {
        Name = "RoboshopDevMysqlRole"
    },
    local.common_tags
  )
}

/* resource "aws_iam_role_policy_attachment" "mysql" {
  role       = aws_iam_role.mysql.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "mysql" {
  name = "RoboshopDevMysqlRole"
  role = aws_iam_role.mysql.name
} */