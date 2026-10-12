# Trust Policy
data "aws_iam_policy_document" "gha_runner_trust_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM Role
resource "aws_iam_role" "gha_runner_role" {
  name               = "${local.resource_name}-gha-runner-role"
  assume_role_policy = data.aws_iam_policy_document.gha_runner_trust_policy.json

  tags = {
    Name    = "${local.resource_name}-eso-role"
    Env     = var.env
    Project = var.project
  }
}

# IAM Policy
resource "aws_iam_policy" "runner_eks_describe" {
  name  = "${var.project}-${var.environment}-runner-eks-describe"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["eks:DescribeCluster"]
        Effect   = "Allow"
        Resource = var.eks_cluster_arn
      },
    ]
  })
}

# IAM Policy Attachment
resource "aws_iam_role_policy_attachment" "runner_eks_describe" {
  role       = aws_iam_role.gha_runner_role.name
  policy_arn = aws_iam_policy.runner_eks_runner_eks_describe.arn
}
