# ------------------------------------------------------------------------------
# IAM Role for EKS Control Plane
# This role is assumed by the EKS service to manage the control plane resources
# ------------------------------------------------------------------------------

resource "aws_iam_role" "eks_cluster" {
  # Unique name for the control plane IAM role
  name = "${local.resource_name}-eks-cluster-role"

  # Trust policy to allow EKS to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })

  tags = {
    Name      = "${var.cluster_name}-role"
    Project   = var.project
    Env       = var.env
    Terraform = true
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Required for advanced networking, Fargate, and Karpenter support (Recommended for Production)
resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSVPCResourceController" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}
