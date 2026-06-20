# resource "aws_instance" "tf_instance_1" {
#   ami = "ami-0220d79f3f480ecf5"
#   instance_type = "t3.micro"
#   vpc_security_group_ids = [aws_security_group.allow_tf.id]

#   tags = {
#     Name = "terraform-state-demo"
#     Project = "roboshop"
#   }
# }


resource "aws_security_group" "allow_tf"{
  name = "allow-all-terraform-change"
  description = "terraform security group allowing the connection on all ports"

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

  tags = {
    Name = "allow-all-terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}