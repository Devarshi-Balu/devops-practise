locals {
    
}


output "merge_output" {
    value = merge({name="deva"}, {age=20}, {year=4}, {name="devarshi"})
}