output "vpc_id" {
    value = aws_vpc.roboshop.id
}

resource "local_file" "output_of_vpc_creation" {
    filename = "${path.module}/vpc_output.json"
    content = indent(2, jsonencode(aws_vpc.roboshop))
}

output availablity_zones_indexing {
    value = {
        for zone in local.availability_zones_roboshop: 
            zone => index(local.availability_zones_roboshop, zone)
    }
}


output final_subnets {
    value = local.subnets
}