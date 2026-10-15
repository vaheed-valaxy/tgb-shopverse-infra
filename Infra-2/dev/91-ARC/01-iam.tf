# Trust Policy - GHA Runner
data "aws_iam_policy_document" "gha_runner_trust_policy" {      
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(local.eks_oidc_provider_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:arc-runners:shopverse-dev-runners-gha-rs-no-permission"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(local.eks_oidc_provider_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [local.eks_oidc_provider_arn]
      type        = "Federated"
    }
  }
}

# IAM Role
resource "aws_iam_role" "gha_runner_role" {
  name               = "${local.resource_name}-gha-runner-role"
  assume_role_policy = data.aws_iam_policy_document.gha_runner_trust_policy.json

  tags = {
    Name    = "${local.resource_name}-gha-runner-role"
    Project = var.project
    Env     = var.env
  }
}

# IAM Policy
resource "aws_iam_policy" "gha_runner_eks_describe_policy" {
  name  = "${local.resource_name}-gha-runner-ecr-push-eks-describe"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      # ======================================================
      # EKS Read
      # ======================================================
      {
        Sid      = "EKS Read"
        Effect   = "Allow"
        Action   = ["eks:DescribeCluster"]
        Resource = local.eks_cluster_arn
      },

      # ======================================================
      # ECR Authentication
      # ======================================================
      {
        Sid    = "ECRAuthentication"
        Effect = "Allow"
        Action = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },

      # ======================================================
      # ECR Upload
      # ======================================================
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:ListImages",
          "ecr:PutImage",
          "ecr:UploadLayerPart"          
        ]

        # Resource = "*"
        # Resource = "arn:aws:ecr:*:${local.aws_account_id}:repository/*"

        Resource = [
          "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/shopverse-dev/*",
          "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/shopverse-qa/*",
          "arn:aws:ecr:${var.region}:${local.aws_account_id}:repository/shopverse/*"
        ]
      }
    ]
  })
}

# IAM Policy Attachment
resource "aws_iam_role_policy_attachment" "gha_runner_eks_describe_policy_attach" {
  role       = aws_iam_role.gha_runner_role.name
  policy_arn = aws_iam_policy.gha_runner_eks_describe_policy.arn
}

# Create IAM instance Role
resource "aws_iam_instance_profile" "gha_runner_instance_role" {
  name  = "${local.resource_name}-gha-runner-instance-role"
  role  = aws_iam_role.gha_runner_role.name
}
