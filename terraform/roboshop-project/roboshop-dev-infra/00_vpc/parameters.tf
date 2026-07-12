resource "aws_ssm_parameter" "vpc_id" {
    name  = "/${var.project}/${var.environment}/vpc_id"
    type  = "String"
    value = module.vpc_main.vpc_details.id
}

resource "aws_ssm_parameter" "public_subnets_ids" {
    name  = "/${var.project}/${var.environment}/public_subnets_ids"
    type  = "StringList"
    value = join(",", local.public_subnets_ids)
}

resource "aws_ssm_parameter" "backend_subnets_ids"{
    name  = "/${var.project}/${var.environment}/backend_subnets_ids"
    type = "StringList"
    value = join(",", local.backend_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnets_ids"{
    name  = "/${var.project}/${var.environment}/database_subnets_ids"
    type = "StringList"
    value = join(",", local.database_subnets_ids)
}