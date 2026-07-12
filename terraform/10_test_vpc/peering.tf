resource "aws_vpc_peering_connection" "roboshop_default" {
  peer_vpc_id   = data.aws_vpc.default.id
  vpc_id        = aws_vpc.main.id

  auto_accept = true # both peer vpc and main vpc are in the same region and belong to the same account

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = merge(local.common_tags, {
    Name = "roboshop-default-vpc-peering-connection"
  })
}

# adding the add the route to the route table of the default vpc
resource "aws_route" "default_to_roboshop" {
    route_table_id = data.aws_vpc.default.main_route_table_id
    destination_cidr_block = aws_vpc.main.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.roboshop_default.id
}