# ---------------------------------------------------------------------
# VPC outputs
# ---------------------------------------------------------------------
output "vpc_id"                  { value = module.vpc.vpc_id   }
output "vpc_cidr"                { value = module.vpc.vpc_cidr }
output "availability_zones"      { value = module.vpc.availability_zones }

output "public_subnet_cidr"      { value = module.vpc.public_subnet_cidr   }
output "private_subnet_cidr"     { value = module.vpc.private_subnet_cidr  }
output "database_subnet_cidr"    { value = module.vpc.database_subnet_cidr }

output "public_subnet_ids"       { value = module.vpc.public_subnet_ids   }
output "private_subnet_ids"      { value = module.vpc.private_subnet_ids  }
output "database_subnet_ids"     { value = module.vpc.database_subnet_ids }

# ---------------------------------------------------------------------
# EKS outputs
# ---------------------------------------------------------------------

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "Endpoint for the EKS cluster API server"
  value       = module.eks.cluster_endpoint
}

output "cluster_ca" {
  description = "Base64 encoded certificate authority data for the EKS cluster"
  value       = module.eks.cluster_ca
}

output "oidc_provider_url" {
  description = "URL of the OIDC Provider for IRSA"
  value       = module.eks.oidc_provider_url
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC Provider for IRSA"
  value       = module.eks.oidc_provider_arn
}

output "cluster_security_group_id" {
  description = "Security group ID automatically created by EKS and attached to managed nodes"
  value       = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  description = "Custom Node Security Group"
  value       = module.eks.node_security_group_id
}
