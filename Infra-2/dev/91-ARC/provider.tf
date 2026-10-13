terraform {

  # required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1.0"
    }

  }

  # Remote Backend
  backend "s3" {
    bucket         = "shopverse-dev-tfstate-123"
    key            = "gha-arc-runner/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true   # Enables native S3 state locking (Terraform 1.10+)
    # encrypt        = true
  }   

}  # terraform end

provider "aws" {
  region = var.region   # "us-east-1"
}
