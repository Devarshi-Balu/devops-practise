output "vpc_id" {
    value = module.vpc_main.vpc_details.id 
}

output "backend_subnets_ids" {
    value =local.backend_subnet_ids
}

output "database_subnets_ids" {
    value = local.backend_subnet_ids
}

output "public_subnets_ids" {  
    value = local.public_subnets_ids
}
