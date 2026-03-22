variable "project" {
    type = string
    default = "roboshop"
  
}

variable "environment" {
    type = string
    default = "dev"
  
}

variable "sg_names" {
    type = list
    default = [
        # Database SGs
        "mongodb", "mysql", "redis", "rabbitmq", 
        # Application SGs
        "catalogue", "cart", "user", "payment", "shipping", 
        # frontend SGs
        "frontend", "frontend-alb",
        # backend alb sg
        "backend-alb",
        # Bastion SG
        "bastion"
        ]
  
}