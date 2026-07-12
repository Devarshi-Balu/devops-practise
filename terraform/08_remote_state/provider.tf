terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "6.33"
        }
    }
    backend "s3" {
        bucket = "devarshi-balu.s3.terraform-roboshop"
        key = "tf-08-remote-state.tfstate"
        region = "us-east-1"
        encrypt = true 
        use_lockfile = true     
        profile = "deva"
    }
}


provider "aws" {
    region = "us-east-1"
    profile = "deva"
}