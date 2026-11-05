# Full Project Execution Flow
## 1. Create the required infrastructure  
```bash
terraform apply -target=module.vpc
terraform apply -target=module.bastion_ec2
terraform apply -target=module.nat_instance
terraform apply -target=module.ecr
terraform apply -target=module.eks
terraform apply -target=module.secrets_manager
terraform apply -target=module.rds

terraform apply argocd
terraform apply eso
terraform apply alb
terraform apply aws-lbc
```

