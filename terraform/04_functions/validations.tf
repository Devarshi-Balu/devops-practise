variable "environment" {
    type = string 
    default = "dev"
    validation {
        condition = contains(["prod", "dev", "qa", "test"], var.environment)
        error_message = "This environment deployment is not supported in this terraform project"
    }
}