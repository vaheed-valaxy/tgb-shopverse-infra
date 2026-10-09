# OIDC Provider
# Data source for TLS certificate needs to be correct.
# Usually we get the OIDC issuer URL from the cluster and then get the thumbprint.
# ServiceAccount → OIDC token → STS Security Token Service verifies identity → STS Security Token Service issues temp creds → IAM role allows alb ingress controller to create ALB

locals {
  oidc_issuer = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

data "tls_certificate" "eks_certificate" {
  url = local.oidc_issuer
  depends_on = [aws_eks_cluster.main]
}

#----------------------------------------------------------------------------------------------------------#
# This should be created only once for entire EKS cluster, so we put it in EKS folder, please be cautious
# 1 EKS cluster = 1 OIDC connector
#-------------------------------------------------------------------------------------------------------- -#
resource "aws_iam_openid_connect_provider" "eks_oidc" {
  client_id_list = ["sts.amazonaws.com"]
  
  # thumbprint_list = [data.tls_certificate.eks_certificate.certificates[0].sha1_fingerprint]   # Always refers to first certificate, so following is the improvement
  
  thumbprint_list = [
    for cert in data.tls_certificate.eks_certificate.certificates :
    cert.sha1_fingerprint
    if cert.is_ca
  ]

  url = local.oidc_issuer

  tags = {
    Name    = "${var.project}-${var.env}-oidc-provider"
    Env     = var.env
    Project = var.project
  }
}
