output "sg_ids" {
    value = {
        for sg_name in var.sg_names: 
            sg_name => data.aws_ssm_parameter.sg_ids[sg_name].value
    }

    sensitive = true
}

output "sg_ids_from_local"{
    value = local.sg_ids["bastion"]
    sensitive = true 
}

output "sg_ids_from_local_2"{
    value = local.sg_ids.bastion
    sensitive = true 
}