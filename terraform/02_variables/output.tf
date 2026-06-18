# output "instance_details" {
#     value = aws_instance.mainserver
# }

# resource "local_file" "tf_for_each_aws_instance_creation" {
#     filename = "${path.module}/for_each_instance.json"
#     content = jsonencode(aws_instance.mainserver)
# }

output "output_upper"{
    value = [for server in local.instance_names: upper(server)]
}

output "output_without_api"{
    value = [
        for server in local.instance_names: upper(server)

        if server != "api"
    ]
}

output "only_api"{
    value = [
        for server in local.instance_names: upper(server)

        if server == "api"
    ]
}

output "name_cpu"{
    value = {
        for server, config in local.servers: 
            server => config["cpu"]
        
        if (config.cpu > 1)
    }
}

output "prod"{
    value = {
        for server, config in local.servers: 
            "prod-${server}" => config.cpu
        
        if (config.cpu > 1)
    }
}

output "test_map_with_for"{
    value = [for server in local.servers: server]
}