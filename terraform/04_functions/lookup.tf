locals {

  server_sizes = {

    web = "t3.micro"
    api = "t3.small"
    db  = "t3.large"

  }

}

output "lookup_output"{
    value = lookup(local.server_sizes, "deva", "notfound")
}