locals {
    instance_names = ["web", "api", "db" ]
}

locals {
  servers = {
    web = {
      instance_type = "t3.micro"
      cpu = "3"
    }

    api = {
      instance_type = "t3.small"
      cpu = "5"
    }

    db = {
      instance_type = "t3.large"
      cpu = "7"
    }
  }
}