# module "first_ec2"{
    
#     source = "../06_modules/modules/ec2_instance"
#     for_each = toset(["cart"])

#     instance_type = "t3.micro"
#     image_id = "ami-0220d79f3f480ecf5"
#     sg_id = aws_security_group.allow_tf.id

#     project = "roboshop-project"
#     environment = "dev"
# }


# output "first_ec2_outputs" {
#     value = {
#         for name, instance in module.first_ec2: 
#             name => {
#                 public_ip = instance.public_ip
#                 instance_id = instance.instance_id
#                 private_ip = instance.private_ip
#             }
#     }
# }

# output "ec2_output_internal"{
#     value = module.first_ec2["cart"]
# }