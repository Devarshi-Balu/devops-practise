resource "aws_instance" "aws_servers"{
    for_each = {
        for name, server in var.servers: 
            name => server
        if (server.env == "prod" && name != "api") 
    }

    instance_type = each.value.instance_type
    ami = var.image_id
    vpc_security_group_ids = [data.aws_security_group.tf_sg.id]

    tags = merge(local.common_tags, 
        {
            Name = each.key
            owner = coalesce(
                        each.value.owner, 
                        "platform-team"
                    )
            Environment = each.value.env
        }
    )
}

data "aws_security_group" "tf_sg"{
    name = "allow-tls-terraform"
    id = "sg-06980adb751c2a7df"
}

output "sg_id" {
    value = "The descrption of the tf_sg security group ${data.aws_security_group.tf_sg.description}"
}