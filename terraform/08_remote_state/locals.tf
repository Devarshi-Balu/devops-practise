locals {  
    valid_environments = ["dev", "qa", "prod"]

    common_tags = {
        ManagedBy = "Terraform"
    }
}   


variable "image_id" {
    type = string
    default = "ami-0220d79f3f480ecf5"  
}


variable "servers" {
    type = map(object({ 
                    instance_type = string,
                    env = string,
                    owner = optional(string)
                }))

    validation {
        condition = alltrue([
                for name, server in var.servers: 
                    contains(local.valid_environments, lower(server.env))    
                ])

        error_message = "invalid environment" 
    }
}