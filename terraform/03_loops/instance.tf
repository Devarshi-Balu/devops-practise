resource "aws_instance" "example" {
  count = 4
  ami = var.image_id
  instance_type = (var.environment == "dev") ? "t3.micro" : "t3.small"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  tags = {
    Name = var.instances[count.index]
    ManagedBy = "terraform"
    Project = "roboshop"
    Environment = var.environment
  }
}

resource "aws_route53_record" "roboshop_records_update" {
  count = 4
  zone_id = var.route_53_hosted_zone_id
  name    = "${var.instances[count.index]}.rb.${var.route53_zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.example[count.index].private_ip]
}

resource "aws_security_group" "allow_tls" {
  name = "allow-all-terraform-change" # this is the security-group-name -- display on the main page -- security-groups "value"
  description = "terraform security group allowing the connection on all ports"

  ingress {
    from_port = 0
    to_port = 0 
    protocol = "-1"
    cidr_blocks = var.roboshop_cidr_block
    ipv6_cidr_blocks = ["::/0"]  
  }
  
  egress {
    from_port = 0
    to_port = 0 
    protocol = "-1"
    cidr_blocks = var.roboshop_cidr_block
    ipv6_cidr_blocks = ["::/0"]  
  }

  tags = {
    Name = var.sg_name
    Terraform = true 
    ManagedBy = "terraform" 
  }

  lifecycle {
    create_before_destroy = true
  }
}