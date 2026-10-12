variable "project"                    { default = "shopverse" }
variable "env"                        { default = "dev" }
variable "region"                     { default = "us-east-1" }

variable "ami_id"                     { default = "ami-0ea87431b78a82070" }
variable "public_key_name"            { default = "us-east-1" }

variable "remote_state_s3_bucket"     { default = "shopverse-dev-tfstate-123" }
variable "remote_state_s3_bucket_key" { default = "shopverse-vpc-eks/terraform.tfstate" }
