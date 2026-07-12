locals{
    servers_2 = {
        api = {
            cpu = 10
        }
        dev = {
            cpu = 20 
        }
        web = {
            cpu = 20
        }    
    }
}


output "contains_output"{
    # value = contains(["api", "web", "dev"], "devarshi")
    value = contains(keys(local.servers_2), "api")
}

