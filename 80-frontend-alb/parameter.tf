resource "aws_ssm_parameter" "public_alb_listner" {
  name        = "/${var.project}/${var.environment}/frontend_alb_listner"
  type        = "SecureString"
  value       = aws_lb_listener.frontend_alb_listener.arn
}
