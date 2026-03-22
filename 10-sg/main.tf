module "sg" {
    count = length(var.sg_names)
    source = "../../terraform-sg"
    project = var.project
    environment = var.environment
    vpc_id = local.vpc_id
    sg_name = var.sg_names[count.index]
    #enable_peering = false

}