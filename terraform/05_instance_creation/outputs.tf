output "aws_instances_output"{
    value = {
        for name, instance in aws_instance.aws_servers: 
            name => {instance_id = instance.id, public_ip=instance.public_ip, private_ip=instance.private_ip}
    }
}
