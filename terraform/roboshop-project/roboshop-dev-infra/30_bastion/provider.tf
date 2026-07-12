terraform {
    required_providers {
        aws = {
        source = "hashicorp/aws"
        version = "6.51.0" # Terraform AWS provider version
        }
    }
     
    # backend "s3" {
    #     bucket  = "devarshi-balu-robsohop-dev" # Replace with your unique bucket name
    #     key     = "roboshop-dev-bastion.tfstate"
    #     region  = "us-east-1"
    #     profile = "deva"
    #     encrypt = true
    #     use_lockfile   = true
    # }
}

provider "aws" {
    region = "us-east-1"
    profile = "deva"
}