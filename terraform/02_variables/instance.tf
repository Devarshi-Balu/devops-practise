resource "aws_instance" "roboshop_mainser" {
    ami = var.image_id
    instance_type = ( var.environment == "dev") ? "t3.micro" : "t3.small"
    vpc_security_group_ids = [aws_security_group.allow_tf.id] 

    tags = var.ec2_tags
}


resource "aws_security_group" "allow_tf"{
  name = "allow-all-terraform-change-2" # this is the security-group-name -- display on the main page -- security-groups "value"
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