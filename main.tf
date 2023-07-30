module "ec2" {
  source = "./modules/ec2-instance"

  for_each = var.ec2_instances

  ami                  = each.value["ami"]
  instance_type        = each.value["instance_type"]
  subnet_id            = each.value["subnet_id"]
  security_group_rules = each.value["security_group_rules"]
  user_data = each.value["user_data"] == null ? null : file(each.value["user_data"])
  key_name             = var.key_name
  tags                 = each.value["tags"]
  vpc_id = var.vpc_id

}

module "load_balancer" {
  source = "./modules/load_balancer"

  vpc_id         = var.vpc_id
  target_id      = lookup(lookup(module.ec2, "jenkins", null ), "ec2_instance_ids", null)
  security_group_rules = var.lb_security_group_rules
  subnets = var.lb_subnets
  tags = var.lb_tags
}

