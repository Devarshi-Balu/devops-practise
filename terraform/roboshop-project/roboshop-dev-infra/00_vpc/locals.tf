locals {

    backend_subnet_ids =  [
        for subnet, subnet_details in module.vpc_main.private_backend_subnets: 
            subnet_details.id
    ]

    database_subnets_ids = [
        for subnet, subnet_details in module.vpc_main.private_database_subnets: 
            subnet_details.id
    ]

    public_subnets_ids = [
        for subnet, subnet_details in module.vpc_main.public_subnets: 
            subnet_details.id
    ]
}

