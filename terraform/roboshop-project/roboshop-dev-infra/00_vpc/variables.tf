variable "project"{
    type = string 
}

variable "environment"{
    type = string 
}

variable "region" {
    type = string 
}

variable "number_of_availability_zones"{
    type = number 
}

variable "peering_to_default_vpc"{
    type = bool 
    default = true
}
