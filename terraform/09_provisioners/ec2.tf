resource "aws_instance" "example"{
    instance_type = "t3.micro"
    ami = "ami-0220d79f3f480ecf5"
    vpc_security_group_ids = [data.aws_security_group.allow_tls.id]

    provisioner "local-exec" {
        command = <<-EOT
            exec > >(tee -a hello.txt) 2>&1
            echo "HI there this is Devarshi Balu"
            echo "Here is the public ip of instance" 
            echo "public_ip = ${self.public_ip}"
            echo "instace created succesfully"        
        EOT
    
        interpreter = ["/bin/bash", "-c"]
        when = destroy
    }

    connection {
        type = "ssh"
        user = "ec2-user"
        password = "DevOps321"
        host = self.public_ip    
    }

    provisioner "remote-exec"{
        when = create 
        script = "install_nginx.sh"
    }

    provisioner "remote-exec"{
        when = destroy
        inline = [
            "sudo systemctl stop nginx"
        ]
    }
    tags = {
        ManagedBy = "Terraform"
        topic = "Learning Provisioners"
    }
}

data "aws_security_group" "allow_tls"{
    name = "allow-tls-terraform"
}