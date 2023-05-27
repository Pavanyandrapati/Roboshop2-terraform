module "vpc" {
  source = "git::https://github.com/Pavanyandrapati/tf-module-vpc-practice-.git"


  for_each =var.vpc
  cidr_block = each.value[cidr_block]

}