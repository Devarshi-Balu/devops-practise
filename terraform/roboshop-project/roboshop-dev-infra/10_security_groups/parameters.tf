resource "aws_ssm_parameter" "sg_ids"{
    for_each = toset(var.sg_names)

    name = "/${var.project}/${var.environment}/sg_ids/${each.value}"
    type = "String" 
    value = aws_security_group.main[each.key].id 
}

