locals {
    backend_service_to_database_array = flatten([
        for db, sources in var.ingress_rule_set_database_service: 
            [
                for source in sources.src: 
                    {   
                        key = "${db}_${source}"
                        value = {
                            db = db 
                            src = source 
                            port = sources.port
                        }
                    }
            ]
    ])

    database_backend = {
        for association in local.backend_service_to_database_array: 
            association.key => association.value
    } 

    backend_service_port = 80

    sg_ids = {
        for name in var.sg_names: 
            name => data.aws_ssm_parameter.sg_ids[name].value
    }

    backend_services = [ "catalogue", "user", "cart", "shipping", "payment" ]
    databases = ["mysql", "mongodb", "redis", "rabbitmq"]
}