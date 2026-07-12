variable "image_id" {
    type = string
    default = "ami-0220d79f3f480ecf5"  
}
variable "environment" {
    type = string 
    default = "dev"
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