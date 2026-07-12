terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "6.52.0"
        }
    }
    # backend "s3" {
    #     bucket = "devarshi-balu-roboshop-dev"
    #     key = "security_groups.tfstate"
    #     region = "us-east-1"
    #     profile = "deva"
    #     encrypt = true 
    #     use_lockfile = true
    # }
}


provider "aws" {
    region = "us-east-1"
    profile = "deva"
}

