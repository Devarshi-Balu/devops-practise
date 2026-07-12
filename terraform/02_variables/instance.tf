resource "aws_instance" "mainserver" {
    for_each = toset(local.instance_names)
    ami = var.image_id
    instance_type = ( var.environment == "dev") ? "t3.micro" : "t3.small"
    vpc_security_group_ids = [aws_security_group.allow_tf.id] 

    tags = {
      Name = each.key
      Project = "roboshop"
      Key_for_each = each.key
      Value_for_each = each.value
    }
}


resource "aws_security_group" "allow_tf"{
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