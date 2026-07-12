data "aws_availability_zones" "azs"{
    region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
  # will be used to get the default vpc id and 
  # the default vpc's main_route_table_id , appending a route to it. 
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

output "zz_default_subnet"{
  value = data.aws_subnets.default_subnets
}