variable "region" {
    type = string
    default = "us-east-1"  
}

variable "number_of_availability_zones"{
    type = number 
    default = 4
}

variable "environment" {
    type = string 
    default = "dev"
    
    validation {
        condition = contains(["dev", "qa", "prod", "test"], var.environment)
        error_message = "This environment is not accepted"
    }
}

variable "project"{
    type = string 
    default = "roboshop"
}

variable "subnets"{
    type = map(object({
        subnet_index = number
        is_private = bool
    }))

    default = {
        "public" = {
            subnet_index = 1
            is_private = false 
        }
        "private-backend" = {
            subnet_index = 2
            is_private = true 
        }
        "private-database" = {
            subnet_index = 3
            is_private = true
        }
    }
}