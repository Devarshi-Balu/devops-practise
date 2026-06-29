resource "aws_vpc" "roboshop"{
    cidr_block  = "10.0.0.0/16"
    region = "us-east-1"

    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "roboshop-dev"
        ManagedBy = "Terraform"
        Project = "roboshop"
        environment = "deva"
    }
}


resource "aws_internet_gateway" "roboshop_ig"{
    vpc_id = aws_vpc.roboshop.id

    tags = merge(local.common_tags, {
        Name = "main_roboshop_gateway"
    })
}

resource "aws_subnet" "roboshop_subnets"{
    for_each = local.subnets

    vpc_id = each.value.vpc_id
    availability_zone = each.value.availability_zone
    cidr_block = each.value.cidr_block

    tags = merge(local.common_tags, 
        {
            Private_subnet = each.value.is_private
        }
    )
}

resource "aws_route_table" "roboshop_private_route_table"{
    vpc_id = aws_vpc.roboshop.id

    route {
        cidr_block = aws_vpc.roboshop.cidr_block
        gateway_id = "local"
    }

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.roboshop_nat.id
    }

    tags = merge(local.common_tags, {private = true})
}

resource "aws_route_table" "roboshop_public_route_table"{
    vpc_id = aws_vpc.roboshop.id

    route {
        cidr_block = aws_vpc.roboshop.cidr_block
        gateway_id = "local"
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.roboshop_ig.id 
    }

    tags = merge(local.common_tags, {private = false})
}


# create a elastic ip 
resource "aws_eip" "roboshop_nat_eip" {
    domain = "vpc"
    tags = local.common_tags
}

# create a natgateway
resource "aws_nat_gateway" "roboshop_nat" {
    allocation_id = aws_eip.roboshop_nat_eip.id
    subnet_id     = aws_subnet.roboshop_subnets["roboshop-public-${local.availability_zones_roboshop[0]}"].id 

    tags = merge(local.common_tags, {Name = "main-nat-gateway"})

    depends_on = [aws_internet_gateway.roboshop_ig]
}

resource "aws_route_table_association" "private" {
  for_each       = local.private_subnets 
  subnet_id      = aws_subnet.roboshop_subnets[each.key].id
  route_table_id = aws_route_table.roboshop_private_route_table.id
}

resource "aws_route_table_association" "public"{
    for_each = local.public_subnets
    subnet_id = aws_subnet.roboshop_subnets[each.key].id
    route_table_id = aws_route_table.roboshop_public_route_table.id
}