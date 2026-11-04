module "rds_mysql_sg" {
  source = "git::https://github.com/vaheedgit26/Infra-1.0.git//modules/sg"

  vpc_id         = module.vpc.vpc_id
  sg_name        = "${local.resource_name}-rds-sg"
  sg_description = "Mysql RDS Instance Security Group"

  common_tags    = local.common_tags
}

# bastion (public_subnet) ---> mysql (database_subnet)
resource "aws_security_group_rule" "bastion_to_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = module.rds_mysql_sg.sg_id

  # depends_on = [module.bastion_sg]
}

# EKS cluster  --->  mysql (database_subnet)
resource "aws_security_group_rule" "backend_to_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.eks.node_security_group_id
  security_group_id        = module.rds_mysql_sg.sg_id

  # depends_on = [module.backend_sg]
}

module "rds" {
  source = "git::https://github.com/vaheedgit26/Infra-1.0.git//modules/rds"
  env    = var.env     # For snapshot, deletion_protection settings
  database_subnet_ids  = module.vpc.database_subnet_ids     # For subnet group creation

  identifier              = local.identifier
  availability_zone       = local.availability_zone        # var.availability_zone
  engine                  = "mysql"
  engine_version          = "8.0.46"
  instance_class          = "db.t3.micro"
  allocated_storage       = 10  # 20
  storage_type            = "gp2"
  storage_encrypted       = false   # true
  db_name                 = "shopverse"
  db_username             = local.shopverse_secret_json.username
  db_password             = local.shopverse_secret_json.password
  db_subnet_group_name    = local.db_subnet_group_name
  vpc_security_group_ids  = [module.rds_mysql_sg.sg_id]

  common_tags = local.common_tags

  depends_on = [ module.rds_mysql_sg, aws_security_group_rule.bastion_to_mysql, aws_security_group_rule.backend_to_mysql ]
}
