output "keys_function"{
    value = values({
        key1 = "value1"
        key2 = "value2"
        key3 = "value3"
    })
}

output "public_subnets"{
    value = local.public_subnets
}

output "private_subnets"{
    value = local.private_subnets
}

output "subnets"{
    value = local.subnets
}