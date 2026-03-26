variable "domain_name" {
  description = "The domain name for which the ACM certificate will be requested."
  type        = string
    default     = "ptdevops.online"
  
}

variable "project" {
    type = string
    default = "roboshop"
  
}

variable "environment" {
    type = string
    default = "dev"

}

variable "zone_id" {
    default = "Z03858732HUVY50OKOZOA"
  
}