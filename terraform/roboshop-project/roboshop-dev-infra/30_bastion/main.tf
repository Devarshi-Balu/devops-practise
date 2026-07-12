resource "aws_instance" "bastion"{
    ami = data.aws_ami.joindevops.id 
    instance_type = "t3.micro"
    subnet_id = local.public_subnet_id

    associate_public_ip_address = true 
    iam_instance_profile = aws_iam_instance_profile.bastion.name
    
    vpc_security_group_ids = [local.bastion_sg_id]

    tags = merge(local.common_tags, {
        Name = "bastion-${var.project}-${var.environment}"
    })
}


resource "aws_iam_role" "bastion" {
    name = "RoboShopDevBastion"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid    = ""
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        },
        ]
    })

    tags = merge(
        {
            Name = "RoboShopDevBastion"
        },
        local.common_tags
    )
}


resource "aws_iam_role_policy_attachment" "bastion" {
  role       = aws_iam_role.bastion.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


resource "aws_iam_instance_profile" "bastion" {
  name = "${var.project}-${var.environment}-bastion"
  role = aws_iam_role.bastion.name
}
