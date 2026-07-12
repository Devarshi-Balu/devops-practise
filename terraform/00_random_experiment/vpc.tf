resource "aws_vpc" "main"{
    region = "us-east-1"

    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = merge(local.common_tags, {
        Name = local.combined_name
    })
}   

resource "aws_subnet" "roboshop_subnets"{
    for_each = local.subnets

    vpc_id = aws_vpc.main.id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone

    map_public_ip_on_launch = each.value.is_private ? "false" : "true"

    tags = merge(local.common_tags, {
        Name = each.key
        is_private = each.value.is_private
    })
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = merge(local.common_tags, {
        Name = "roboshop-dev-us-east-1-IG"
        Vpc = aws_vpc.main.tags.Name
    })
}

resource "aws_eip" "nat_ip" {
    domain = "vpc"

    depends_on = [ aws_internet_gateway.main ]
    tags = merge(local.common_tags, {Name = "${local.combined_name}-nat-ip"}) 
}

resource "aws_nat_gateway" "roboshop_private" {
    allocation_id = aws_eip.nat_ip.id
    subnet_id     = aws_subnet.roboshop_subnets[keys(local.public_subnets)[0]].id
    tags = merge(local.common_tags, {
        Name = "roboshop-dev-us-east-1-NAT"
    })
}

resource "aws_route_table" "private_subnets" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = aws_vpc.main.cidr_block
        gateway_id = "local"
    }

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.roboshop_private.id
    }

    tags = merge(local.common_tags, {
        Name = "roboshop-dev-private"
    })
}

resource "aws_route_table" "public_subnets" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = aws_vpc.main.cidr_block
        gateway_id = "local"
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id =  aws_internet_gateway.main.id
    }

    tags = merge(local.common_tags, {
        Name = "roboshop-dev-public"
    })
}

resource "aws_route_table_association" "public_subnets" {
    for_each = local.public_subnets
    subnet_id      = aws_subnet.roboshop_subnets[each.key].id
    route_table_id = aws_route_table.public_subnets.id
}

resource "aws_route_table_association" "private_subnets" {
    for_each = local.private_subnets
    subnet_id      = aws_subnet.roboshop_subnets[each.key].id
    route_table_id = aws_route_table.private_subnets.id
}


resource "aws_security_group" "allow_all_traffic"{
    name = "allow-all-traffic-roboshop-dev-vpc"
    description = "security group for allowing all the traffic in the roboshop dev vpc"

    vpc_id = aws_vpc.main.id
    
    ingress {
        from_port = 0
        to_port = 0 
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    egress {
        from_port = 0
        to_port = 0 
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    lifecycle {
      create_before_destroy = true
    }

    tags = merge(local.common_tags, {Name = "Allow all traffic inside Roboshop vpc"})
}

resource "aws_instance" "private_1" {
    ami                         = local.devops_practise_ami_id 
    instance_type               = "t3.micro"
    subnet_id                   = aws_subnet.roboshop_subnets[keys(local.private_subnets)[0]].id
    
    associate_public_ip_address = false
    vpc_security_group_ids = [aws_security_group.allow_all_traffic.id]

    tags = {
        Name = "private_instance-1"
    }
    
    provisioner "local-exec" {
        command = "echo The private-ip of the instance is : ${self.private_ip} " 
    }
}

resource "aws_instance" "public_1" {
    ami                         = local.devops_practise_ami_id 
    instance_type               = "t3.micro"
    subnet_id                   = aws_subnet.roboshop_subnets[keys(local.public_subnets)[0]].id
    
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.allow_all_traffic.id]
    
    tags = {
        Name = "public_instance-1"
    }


    provisioner "local-exec" {
        command = "echo The public ip of the instance is : ${self.public_ip}"  
    }
}