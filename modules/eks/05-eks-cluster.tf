# -------------------------------------------------------------------------------
# Create the AWS EKS Cluster ( This is the control plane for Kubernetes on AWS )
# -------------------------------------------------------------------------------
resource "aws_eks_cluster" "main" {

  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_cluster.arn

  # VPC configuration for control plane networking
  vpc_config {
    subnet_ids              = var.cluster_subnet_ids
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    # security_group_ids      = var.cluster_addl_security_group_ids      # For Cluster to Node and vice versa communication
  }

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"            # Three options: API, CONFIG_MAP, API_AND_CONFIG_MAP
    bootstrap_cluster_creator_admin_permissions = true    # Gives admin access to user who creates this EKS Cluster
  }

  # Ensure IAM policy attachments complete before cluster creation
  # Helps avoid race conditions during provisioning and destroy
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSVPCResourceController
  ]

  tags = {
    Name      = "${var.cluster_name}"
    Env       = var.env
    Project   = var.project
    Terraform = true
  }

}

# Allow EKS cluster access from Bastion Host on Port: 443
resource "aws_security_group_rule" "eks_api_from_bastion" {
  count = ( var.cluster_endpoint_public_access == false || var.enable_bastion_access ) ? 1 : 0

  type                     = "ingress"
  from_port                = 443        # 0          
  to_port                  = 443        # 0          
  protocol                 = "tcp"      # "-1"       
  security_group_id        = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id
  source_security_group_id = var.bastion_sg_id
  description              = "Allow bastion to access EKS API"
}
