data "aws_ssm_parameter" "sg_ids"{
    for_each = toset(var.sg_names)
    name = "/${var.project}/${var.environment}/sg_ids/${each.key}"
}