# Security Group for EKS Node Group
resource "aws_security_group" "eks_node_sg" {
  name        = "${var.cluster_name}-node-sg"
  description = "Additional security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  # egress {
  #   from_port        = 0
  #   to_port          = 0
  #   protocol         = "-1"
  #   cidr_blocks      = ["0.0.0.0/0"]
  #   ipv6_cidr_blocks = ["::/0"]
  # }

  tags = {
    Name      = "${var.cluster_name}-node-sg"
    Project   = var.project
    Env       = var.env
    Terraform = "true"
  }
}

# Bastion to EKS node SSH
resource "aws_security_group_rule" "bastion_to_eks_node_ssh" {
  count = var.enable_node_ssh_access_from_bastion ? 1: 0

  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_node_sg.id
  source_security_group_id = var.bastion_sg_id
}

# Launch Template for Node Group
resource "aws_launch_template" "eks_nodes" {
  count = var.enable_node_ssh_access_from_bastion ? 1: 0

  name_prefix = "${var.cluster_name}-nodes-"

  key_name = var.node_ssh_key_name

  vpc_security_group_ids = [
    aws_eks_cluster.main.vpc_config[0].cluster_security_group_id,
    aws_security_group.eks_node_sg.id
  ]

  # Tags applied to the launch template resource
  tags = {
    Project = var.project
    Env     = var.env
  }

  # Tags applied to EC2 instances launched from this template
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "${var.cluster_name}-node"
      Project = var.project
      Env     = var.env
    }
  }
}
