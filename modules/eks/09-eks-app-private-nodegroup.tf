# EKS Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-app-node-group"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = var.node_subnet_ids
  instance_types  = var.app_node_instance_types
  capacity_type   = var.app_node_capacity_type   # ON_DEMAND/ SPOT
  # disk_size       = var.node_disk_size        # Not needed if you use launch template and gives error

  #remote_access {
  #  ec2_ssh_key               = var.node_ssh_public_key    # "my-key"
  #  source_security_group_ids = var.node_addl_sg_ids       # [bastion_sg]
  #}

  # For Node group Security group
  # dynamic "launch_template" {
  #   for_each = var.enable_node_ssh_access_from_bastion ? [1] : []

  #   content {
  #     id      = aws_launch_template.eks_nodes.id
  #     version = tostring(aws_launch_template.eks_nodes.latest_version)
  #   }
  # }

  # For Node group Security group
  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = tostring(aws_launch_template.eks_nodes.latest_version)
  }

  scaling_config {
    min_size     = var.app_node_min_size
    max_size     = var.app_node_max_size
    desired_size = var.app_node_desired_capacity
  }

  update_config {
    # max_unavailable_percentage = 33
    max_unavailable = 1
  }

  # taints {
  #   key    = "dedicated"
  #   value  = "application"
  #   effect = "NO_SCHEDULE"
  # }
  
  # Force node group update when EKS AMI version changes
  # force_update_version = true

  # Apply labels to each EC2 instance for easier scheduling and management in Kubernetes
  labels = {
    "project"  = var.project
    "env"      = var.env
    "workload" = "application"
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.node_AmazonSSMManagedInstanceCore
  ]

  tags = merge(
    {
      Name      = "${var.cluster_name}-app-node-group"
      Project   = var.project
      Env       = var.env
      Terraform = true
    },
    var.node_auto_scaler_tags
  )
}
