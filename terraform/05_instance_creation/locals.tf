locals {  
    valid_environments = ["dev", "qa", "prod"]

    common_tags = {
        ManagedBy = "Terraform"
    }
}   
