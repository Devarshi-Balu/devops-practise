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
