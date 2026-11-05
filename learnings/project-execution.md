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
## 2. If u want ARC Runner for CI
```bash
terraform apply ARC
```
## 3. Create ESO secrets in kubernetes
repo: `tgb-shopverse-gitops`
```bash
cd k8s/eso-external-secrets

kubectl apply -f cluster-secret-store.yaml
kubectl apply -f dev-external-secrets.yaml
```
## 4. If u want ARC Runner 
**4.1 for CI**  
repo: `tgb-shopverse-gitops`  
```bash
cd k8s/rbac/platform

kubectl apply -f gha-arc-runner-sa.yaml
```
**4.2 for GITOPS** 
repo: `tgb-shopverse-gitops`  
```bash
cd k8s/rbac/platform

kubectl apply -f gitops-arc-runner-sa-perms.yaml
```



