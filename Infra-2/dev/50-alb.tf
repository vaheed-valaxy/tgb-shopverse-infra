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
  security_group_id = module.alb_sg.sg_id                       
}

# ALB Module Calling
module "alb" {
  source = "git::https://github.com/vaheedgit26/Infra-1.0.git//modules/alb"

  internal = false
  internal              = false
  alb_sg_ids            = [local.web_alb_sg_id]
  subnets               = module.vpc.public_subnet_ids  
  vpc_id                = module.vpc.vpc_id

  project_name = var.project
  env          = var.env
  common_tags  = var.common_tags
}
