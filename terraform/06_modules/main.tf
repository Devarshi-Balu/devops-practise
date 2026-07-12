module "person1" {
  source = "./modules/test"
  name = "Deva"
}

module "person2" {
  source = "./modules/test"
  name = "Rajesh"
}

module "person3" {
    source = "./modules/test"
    name = "raj"
}


output "test_greeting"{
    value = module.person3.greeting
}