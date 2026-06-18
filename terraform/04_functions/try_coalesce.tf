locals {
    servers_try =  {    
        web = {
            cpu = 10
        }
        api = {
            instance_type = "t3.nano"
        }
    }
}


output z_try_out{
    value = coalesce(try(local.servers_try.api.cpu, null), "hello")
}