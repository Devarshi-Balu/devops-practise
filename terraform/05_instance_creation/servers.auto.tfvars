servers = {
        web = {
            instance_type = "t3.micro"
            env           = "dev"
            owner = "dev-team"
        }

        api = {
            instance_type = "t3.micro"
            env           = "prod"
            owner = "production-team"
        }

        db = {
            instance_type = "t3.micro"
            env           = "prod"
        }
    }     