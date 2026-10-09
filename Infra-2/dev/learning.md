## 1. Create the additional node security group
**In security-groups.tf:**
```hcl
resource "aws_security_group" "node" {
  name        = "${var.cluster_name}-node-sg"
  description = "Additional security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.cluster_name}-node-sg"
  }
}
```
Add the necessary ingress and egress rules separately. For example, allow your ALB security group to access the application ports.

## 2. Create the launch template
In `launch-template.tf`:
