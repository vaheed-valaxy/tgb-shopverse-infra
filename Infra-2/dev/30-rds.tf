module "rds" {
  source = "git::https://github.com/vaheedgit26/Infra-1.0.git//modules/rds"
  env    = var.env     # For snapshot, deletion_protection settings
  database_subnet_ids  = module.vpc.database_subnet_ids     # For subnet group creation

  identifier              = local.identifier
  availability_zone       = local.availability_zone        # var.availability_zone
  engine                  = "mysql"
  engine_version          = "8.0.44"
  instance_class          = "db.t3.micro"
  allocated_storage       = 10  # 20
  storage_type            = "gp2"
  storage_encrypted       = false   # true
  db_name                 = "shopverse"
  db_username             = local.shopverse_secret_json.username
  db_password             = local.shopverse_secret_json.password
  db_subnet_group_name    = local.db_subnet_group_name
  vpc_security_group_ids  = local.rds_vpc_security_group_ids

  common_tags = local.common_tags
}
