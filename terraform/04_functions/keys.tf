locals {
  servers = {
    web = {
      cpu = 2
    }
    api = {
      cpu = 4
    }
    db = {
      cpu = 8
    }
  }

  server_ips = {
    "web" = "10.0.1.10"
    "api" = "10.0.1.20"
    "db"  = "10.0.1.30"
  }
}

output "keys_output"{
    value = keys(local.servers)
}


output "values_output"{
    value = values(local.servers)
}


output "ips_of_servers"{
    value = zipmap(keys(local.servers), values(local.server_ips))
}