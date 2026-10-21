# EKS Node Group
resource "aws_eks_node_group" "ci" {
  count = var.create_ci_nodegroup ? 1 : 0

  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-ci-node-group"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = var.node_subnet_ids
  instance_types  = var.ci_node_instance_types
  capacity_type   = var.ci_node_capacity_type   # ON_DEMAND / SPOT
  # disk_size       = var.node_disk_size        # Not needed if you use launch template and gives error

  # For Node group Security group
  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = tostring(aws_launch_template.eks_nodes.latest_version)
  }

  scaling_config {
    min_size     = var.ci_node_min_size
    max_size     = var.ci_node_max_size
    desired_size = var.ci_node_desired_capacity
  }

  update_config {
    # max_unavailable_percentage = 33
    max_unavailable = 1
  }

  taint {
    key    = "dedicated"
    value  = "ci"
    effect = "NO_SCHEDULE"
  }

  # Force node group update when EKS AMI version changes
  # force_update_version = true

  # Apply labels to each EC2 instance for easier scheduling and management in Kubernetes
  labels = {
    "project"  = var.project
    "env"      = var.env
    "workload" = "ci"
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.node_AmazonSSMManagedInstanceCore
  ]

  tags = merge(
    {
      Name      = "${var.cluster_name}-ci-node-group"
      Project   = var.project
      Env       = var.env
      Terraform = true
    },
    var.node_auto_scaler_tags
  )
}
