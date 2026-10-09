locals {
  resource_name = "${var.project}-${var.env}"

  common_tags = {
      Project     = var.project
      Environment = var.env
      Terraform   = "True"
    }
}
