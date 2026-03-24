resource "aws_ssm_parameter" "backend_alb_listner" {
  name        = "/${var.project}/${var.environment}/backend_alb_listner"
  type        = "SecureString"
  value       = aws_lb_listener.backend_alb_listener.arn
}
