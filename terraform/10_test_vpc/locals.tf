locals {
    environment = "dev"
    project = "roboshop"
    number_of_zones = 2

    common_tags = {
        Environment = local.environment
        Project = local.project 
        ManagedBy = "terraform"
    }

    availability_zones_roboshop = slice(data.aws_availability_zones.roboshop_zones.names, 0, local.number_of_zones)
    availability_zones_ids_roboshop = slice(data.aws_availability_zones.roboshop_zones.zone_ids, 0, local.number_of_zones)

    zones_idxs = {
        for zone in local.availability_zones_roboshop: 
            zone => index(local.availability_zones_roboshop, zone)
    }

    subnet_types = {
        public   = 1
        private-backend  = 2
        private-database = 3
    }

    subnet_list = [
        for subnet, subnet_number in local.subnet_types:
            [
                for zone, z_idx in local.zones_idxs: 
                {
                    key = "roboshop-${subnet}-${zone}"
                    value = {
                        cidr_block = "10.0.${subnet_number}${z_idx}.0/24"
                        availability_zone = zone
                        vpc_id = aws_vpc.roboshop.id
                        is_private = (subnet != "public") 
                    }
                }
            ] 
    ]

    subnets = {
        for subnet in flatten(local.subnet_list): 
            subnet.key => subnet.value
    }

    private_subnets = {
        for key, value in local.subnets: 
            key => value
        if (value.is_private) 
    }

    public_subnets = {
        for key, value in local.subnets: 
            key => value
        if !(value.is_private) 
    }
}


