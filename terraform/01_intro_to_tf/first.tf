resource "aws_instance" "example_instance"{
  ami = local.amazon_ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_terraform_rev.id]

  tags = {
    Name = "Roboshop-tf-rev-instance"
    ManagedBy = "terraform"
  }
}

data "aws_security_group" "allow_all_terraform"{
  id = "sg-040ff8eef277574d8"
} 

resource "aws_security_group" "allow_terraform_rev"{
  name = "allow-terraform-rev"
  description = "allow all traffic from the internet"

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

  tags = {
    ManagedBy = "terraform"
    project = "demo-roboshop"
    dummy = "true"
  }
}