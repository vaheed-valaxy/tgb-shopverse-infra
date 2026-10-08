# Security Group for Bastion Host
module "alb_sg" {
  source = "git::https://github.com/vaheedgit26/Infra-1.0.git//modules/sg"

  vpc_id         = module.vpc.vpc_id
  sg_name        = local.alb_sg_name
  sg_description = "ALB Security Group"

  common_tags    = local.common_tags
}

# Security Group Rule for ALB
resource "aws_security_group_rule" "alb_internet" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.alb_sg.sg_id                       # aws_security_group.sg_nat_instance.id
}

# Security Group Rule for Bastion Host (For Argocd access)
resource "aws_security_group_rule" "bastion_argocd" {
  type              = "ingress"
  from_port         = 8090
  to_port           = 8090
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.sg_id                       # aws_security_group.sg_nat_instance.id
}
