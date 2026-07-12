locals {
    common_tags = {
        Project = var.project
        Environment = var.environment
        ManagedBy = "Terraform" 
    }

    amazon_ami_id = "ami-08f44e8eca9095668"
    devops_practise_ami_id = "ami-0220d79f3f480ecf5"
    
    combined_name = "${var.project}-${var.environment}-${var.region}"


    azs = slice(data.aws_availability_zones.azs.names, 0, var.number_of_availability_zones)

    azs_idxs = {
        for az in local.azs: 
            az => index(local.azs, az)
    }

    subnets_array = flatten([
        for subnet, sub_details in var.subnets: 
            [
                for az, idx in local.azs_idxs:
                    {
                        key = "${var.project}-${var.environment}-${subnet}-${az}"
                        value = {
                            cidr_block = "10.0.${sub_details.subnet_index}${idx}.0/24"
                            availability_zone = az
                            is_private = sub_details.is_private
                        } 
                    } 
            ]
        ])

    subnets = {
        for subnet in local.subnets_array: 
            subnet.key => subnet.value
    }   

    private_subnets = {
        for k, v in local.subnets: k => v if (v.is_private)
    }

    public_subnets = {
        for k, v in local.subnets: k => v if (!v.is_private)
    }
}