variable "sg_names"{
    type = list(string)
    
    default = [
        # Databases
        "mongodb", "redis", "mysql", "rabbitmq",

        # Backend
        "catalogue", "user", "cart", "shipping", "payment",

        # ALBs
        "backend_alb",
        "frontend_alb",

        # Frontend
        "frontend",

        # Bastion
        "bastion",   
    ]
}

variable "project"{
    type = string
    default = "roboshop" 
}

variable "environment"{
    type = string 
    default = "dev"
}

variable "region" {
    type = string
    default = "us-east-1" 
}


variable "ingress_rule_set_database_service" {
    type = map(object({
        src = list(string)
        port = number 
        protocol = optional(string, "tcp")
    }))


    /* example 
        mongodb = [
            {
                src: "user"
                port: 27017
            },
            {
                src: "catalogue"
                port: 27017
            }
        ]
    */

    default = {
        mongodb = {
            src = ["catalogue", "user"]
            port = 27017
        }

        redis = {
            src = ["user", "cart"]
            port = 6379
        }

        mysql = {
            src = ["shipping"]
            port = 3306
        }

        rabbitmq = {
            src = ["payment"]
            port = 5672
        }
    }
}