
resource "aws_security_group" "allow_all_traffic"{
    for_each =  {
        roboshop =  aws_vpc.main.id
        default  = data.aws_vpc.default.id      
    }

    name = "allow-all-traffic-roboshop-dev-vpc"
    description = "security group for allowing all the traffic in the roboshop dev vpc"

    vpc_id = each.value
    
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
    vpc_security_group_ids = [aws_security_group.allow_all_traffic["roboshop"].id]

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
    vpc_security_group_ids = [aws_security_group.allow_all_traffic["roboshop"].id]
    
    tags = {
        Name = "public_instance-1"
    }

}

resource "aws_instance" "public_default" {
    ami                         = local.devops_practise_ami_id 
    instance_type               = "t3.micro"
    subnet_id                   = data.aws_subnets.default_subnets.ids[0]

    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.allow_all_traffic["default"].id]
    
    tags = {
        Name = "public_instance_2 - default"
    }
}