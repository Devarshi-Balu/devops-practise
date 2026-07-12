resource "aws_security_group" "main" {
    for_each = toset(var.sg_names)

    name = "${each.key}"
    description  = "security group of ${each.key} instance"
    vpc_id = data.aws_ssm_parameter.vpc_id.value

    tags = {
        Name = "${var.project}-${var.environment}-${each.key}"
        Project = "${var.project}"
        Managedby = "terraform"
    }
}

resource "aws_vpc_security_group_egress_rule" "outbound" {
    for_each = toset(var.sg_names)

    security_group_id = aws_security_group.main[each.key].id
    cidr_ipv4         = "0.0.0.0/0"
    ip_protocol       = "-1" 
}

