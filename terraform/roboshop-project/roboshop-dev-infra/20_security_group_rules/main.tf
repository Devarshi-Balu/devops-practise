# bastian ingress rule -> allowing the internet traffic to it. 
resource "aws_vpc_security_group_ingress_rule" "bastian_internet"{
    security_group_id = local.sg_ids.bastion
    from_port = 22 
    to_port = 22
    ip_protocol = "tcp"
    cidr_ipv4 = "0.0.0.0/0" // replace with ip address for tighter security   
}

# allowing bastian to connect to all the other instances 
resource "aws_vpc_security_group_ingress_rule" "bastian_ssh"{
    for_each = toset([
        for name in var.sg_names: name if (name != "bastion") 
    ])

    security_group_id = local.sg_ids[each.key]
    from_port = 22 
    to_port = 22
    ip_protocol = "tcp"
    referenced_security_group_id = local.sg_ids.bastion
}

# allowing backends to connect to the database 
resource "aws_vpc_security_group_ingress_rule" "database_backend"{
    for_each = local.database_backend

    security_group_id = local.sg_ids[each.value.db]
    from_port = each.value.port
    to_port = each.value.port 
    ip_protocol = "tcp"
    referenced_security_group_id = local.sg_ids[each.value.src]
}

# allowing the backend_alb to connect to the backendservices
resource "aws_vpc_security_group_ingress_rule" "backend_service_backend_alb"{
    for_each = toset(local.backend_services)

    security_group_id = local.sg_ids[each.key]
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    referenced_security_group_id = local.sg_ids.backend_alb
}

# allowing backend_services to connect to the backend_alb 
resource "aws_vpc_security_group_ingress_rule" "backend_alb_backend_service"{
    for_each = toset(local.backend_services)

    security_group_id = local.sg_ids.backend_alb
    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    referenced_security_group_id = local.sg_ids[each.key]
}

# allowing the frontend to connect to the backend_alb
resource "aws_vpc_security_group_ingress_rule" "backend_alb_frontend"{
    security_group_id = local.sg_ids.backend_alb
    from_port         = 80
    to_port           = 80
    ip_protocol       = "tcp"
    referenced_security_group_id = local.sg_ids.frontend      
} 

# allowing the frontend_alb to connect to the frontend 
resource "aws_vpc_security_group_ingress_rule" "frontend_frontend_alb" {
    security_group_id = local.sg_ids.frontend
    from_port         = 80
    to_port           = 80
    ip_protocol       = "tcp"
    # Where traffic is coming from
    referenced_security_group_id = local.sg_ids.frontend_alb
}

# Frontend ALB
resource "aws_vpc_security_group_ingress_rule" "frontend_alb_public" {
    security_group_id = local.sg_ids.frontend_alb
    from_port         = 443
    to_port           = 443
    ip_protocol       = "tcp"
    cidr_ipv4         = "0.0.0.0/0"
}