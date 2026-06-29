data "aws_availability_zones" "roboshop_zones" {
    region = "us-east-1"
}


output "availability_zones_us_east_1"{
    value = data.aws_availability_zones.roboshop_zones
}

