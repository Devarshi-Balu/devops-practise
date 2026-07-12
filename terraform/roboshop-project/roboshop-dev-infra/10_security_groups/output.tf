output "security_groups_id"{
    value = {
        for name in var.sg_names: 
            name => aws_security_group.main[name].id
    }
}