output "instance_ids" {
    value = aws_instance.example[*].id
    description = "output of the aws instances creation"
}

output "instance_public_ips" {
    value = aws_instance.example[*].public_ip
}

resource "local_file" "instances_json_file" {
    filename = "${path.module}/instances.json"
    content  = indent(2, jsonencode(aws_instance.example))
}

resource "local_file" "route53json" {
    filename = "${path.module}/dns_records.json"
    content = indent(2, jsonencode(aws_route53_record.roboshop_records_update))
}