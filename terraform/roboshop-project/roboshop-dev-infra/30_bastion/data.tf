data "aws_ami" "joindevops" {
    most_recent      = true
    owners           = ["973714476881"]

    filter {
        name   = "name"
        values = ["Redhat-9-DevOps-Practice"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}


data "aws_ssm_parameter" "public_subnets_ids"{
    name = "/${var.project}/${var.environment}/public_subnets_ids"
}

data "aws_ssm_parameter" "database_subnets_ids"{
    name = "/${var.project}/${var.environment}/database_subnets_ids"
}

data "aws_ssm_parameter" "backend_subnets_ids"{
    name = "/${var.project}/${var.environment}/backend_subnets_ids"
}

data "aws_ssm_parameter" "bastion_sg_id"{
    name = "/${var.project}/${var.environment}/sg_ids/bastion"
}