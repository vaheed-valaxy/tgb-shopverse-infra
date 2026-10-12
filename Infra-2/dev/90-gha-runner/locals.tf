locals {
  resource_name = "${var.project}-${var.env}"

  common_tags = {
    Project     = var.project
    Environment = var.env
    Terraform   = "True"
  }

  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  eks_cluster_arn   = data.terraform_remote_state.eks.outputs.cluster_arn
}
