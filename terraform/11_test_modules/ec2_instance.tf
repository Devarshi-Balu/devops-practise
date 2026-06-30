module "ec2_instance"{
    source = "git::ssh://github-personal/devarshi-balu/terraform-modules//ec2_module?ref=main"
    # source = "git::github.com/devarshi-balu/terraform-modules//ec2_module?ref=main"
    
}