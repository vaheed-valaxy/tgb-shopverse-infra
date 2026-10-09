# Security Group for EKS Node Group
module "node_sg" {
  source = "git::https://github.com/vaheedgit26/Infra-1.0.git//modules/sg"

  vpc_id         = var.vpc_id
  sg_name        = "${var.cluster_name}-node-sg"
  sg_description = "EKS Node Security Group"

  common_tags    = local.common_tags
}

# Launch Template for Node Group
resource "aws_launch_template" "eks_nodes" {
  name_prefix = "${var.cluster_name}-nodes-"

  key_name = var.node_key_name

  vpc_security_group_ids = [
    aws_eks_cluster.main.vpc_config[0].cluster_security_group_id,
    module.node_sg.sg_id
  ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "${var.cluster_name}-node"
      Project = var.project
      Env     = var.env
    }
  }
}
