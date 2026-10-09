# Security Group for EKS Node Group
module "node_sg" {
  source = "git::https://github.com/vaheedgit26/Infra-1.0.git//modules/sg"

  vpc_id         = module.vpc.vpc_id
  sg_name        = "${local.resource_name}-node-sg"
  sg_description = "EKS Node Group Security Group"

  common_tags    = local.common_tags
}
