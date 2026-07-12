resource "aws_instance" "aws_servers"{
    for_each = {
        for name, server in var.servers: 
            name => server
        if (server.env == "prod")
    }
    
    instance_type = each.value.instance_type
    ami = var.image_id
    vpc_security_group_ids = [aws_security_group.allow_tls.id]

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

