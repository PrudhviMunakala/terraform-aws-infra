module "vpc" {
    source = "git::https://github.com/PrudhviMunakala/terraform-vpc-module.git?ref=main"
    #source = "../../terraform-vpc"
    project = var.project
    environment = var.environment
    enable_peering = true


    

}