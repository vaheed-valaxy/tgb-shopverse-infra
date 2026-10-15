variable "project"                    { default = "shopverse" }
variable "env"                        { default = "dev" }
variable "region"                     { default = "us-east-1" }

variable "remote_state_s3_bucket"     { default = "shopverse-dev-tfstate-123" }
variable "remote_state_s3_bucket_key" { default = "shopverse-vpc-eks/terraform.tfstate" }

variable "github_org"   { default = "vaheed-valaxy" }
variable "github_repo"  { default = "tgb-shopverse-gitops" }
variable "github_token" { sensitive = true }

variable "gha_arc_runner_role_arn" {}
