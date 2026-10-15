# HELM Provider
provider "helm" {
  kubernetes = {
    host                   = local.eks_host
    cluster_ca_certificate = base64decode(local.eks_cluster_ca_certificate)
    token                  = local.eks_token  # data.aws_eks_cluster_auth.cluster.token
  }
}

# Terraform Kubernetes Provider
provider "kubernetes" {
  host                   = local.eks_host 
  cluster_ca_certificate = base64decode(local.eks_cluster_ca_certificate)
  token                  = local.eks_token    # data.aws_eks_cluster_auth.cluster.token
}

# Terraform Kubernetes Provider (This is also good to use)
# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.cluster_ca)

#   exec {
#     api_version = "client.authentication.k8s.io/v1"    # v1beta1
#     command     = "aws"
#     args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
#   }
# }
