# Security Group for ALB
module "alb_sg" {
  source = "git::https://github.com/vaheedgit26/Infra-1.0.git//modules/sg"

  vpc_id         = module.vpc.vpc_id
  sg_name        = local.alb_sg_name
  sg_description = "ALB Security Group"

  common_tags    = local.common_tags
}

# ALB allowing traffic from internet
resource "aws_security_group_rule" "internet_to_alb" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.alb_sg.sg_id 
}

# Allowing traffic from ALB to EKS nodes
resource "aws_security_group_rule" "alb_to_nodegroup" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = module.eks.node_security_group_id
  source_security_group_id = module.alb_sg.sg_id 
}

# ALB Module Calling
module "alb" {
  source = "git::https://github.com/vaheedgit26/Infra-1.0.git//modules/alb"

  alb_name     = "${local.resource_name}-alb"
  internal     = false
  alb_sg_ids   = [module.alb_sg.sg_id]
  subnets      = module.vpc.public_subnet_ids 

  target_type  = "ip"
  vpc_id       = module.vpc.vpc_id

  listener_mode = "http"    # https, http_to_https
  # acm_certificate_arn = var.acm_certificate_arn

  services = {
    frontend = {
      tg_name       = "frontend-tg"
      port          = 8080
      health_path   = "/health"
      path_patterns = ["/*"]
      priority      = 200
    }

    backend = {
      tg_name       = "backend-tg"
      port          = 8080
      health_path   = "/health"
      path_patterns = ["/api/*"]
      priority      = 100
    }
  }

  project      = var.project
  env          = var.env
  common_tags  = local.common_tags

  depends_on = [ module.alb_sg, aws_security_group_rule.internet_to_alb", aws_security_group_rule.alb_to_nodegroup ]
}
