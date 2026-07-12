variable "image_id" {
    type = string
    default = "ami-0220d79f3f480ecf5"  
}
variable "instances" {
    type = list 
    default = ["mongodb", "redis", "mysql", "frontend"]
}

# variable "instances" {
#     type = list 
#     default = ["mongodb", "redis", "mysql", "rabbitmq", "catalogue", "cart", "user", "shipping", "payment", "frontend"]
# }

variable "environment" {
    type = string 
    default = "dev"
}

variable route_53_hosted_zone_id {
    type = string 
    default = "Z06569691EDOCEFWDOVQV"
}

variable route53_zone_name {
    type = string 
    default = "devarshi.live"
}

variable "ec2_tags" {
    type = map
    default = {
        Name = "terraform-state-demo"
        Project = "roboshop"
        ManagedBy = "terraform"
        Terraform = "true"
        environment = "dev"
    }
}

variable "ec2_default_type" {
    type = string 
    default = "t3.micro"
}

variable "roboshop_cidr_block" {
    type = list 
    default = ["0.0.0.0/0"]  
}


variable "sg_name" {
    type = string 
    default = "sg-name-from-varibales-vars.tf"
}