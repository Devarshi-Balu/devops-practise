module "vpc_main"{
    # source = "git::ssh://git@github-personal/devarshi-balu/terraform-modules//vpc?ref=main"
    # source = "git::ssh://github-personal/devarshi-balu/terraform-modules//vpc?ref=main"
    source = "git::https://github.com/devarshi-balu/terraform-modules//vpc?ref=main"
    
    project = var.project 
    environment = var.environment
    region = var.region 
    number_of_availability_zones = var.number_of_availability_zones
    peering_to_default_vpc = var.peering_to_default_vpc
}

