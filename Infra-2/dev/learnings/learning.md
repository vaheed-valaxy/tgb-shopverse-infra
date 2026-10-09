## 1. Create the additional node security group
In `security-groups.tf`:   
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
```hcl
resource "aws_launch_template" "eks_nodes" {
  name_prefix = "${var.cluster_name}-nodes-"

  vpc_security_group_ids = [
    aws_eks_cluster.this.vpc_config[0].cluster_security_group_id,
    aws_security_group.node.id
  ]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.cluster_name}-node"
    }
  }
}
```
This assumes your cluster resource is named `aws_eks_cluster.this` and your module defines `var.cluster_name` and `var.vpc_id`.  
Do not create a second `aws_eks_node_group` if you already have one.  

**Important before applying**  
- Include the EKS cluster security group explicitly because specifying security groups in the launch template means EKS will not automatically add that security group for you.  
- Make sure the additional security group has the required rules for cluster communication and application traffic. The snippet above does not configure those rules.  
- If your existing managed node group was created without a custom launch template, adding one may require replacing or migrating the node group. Check your Terraform plan carefully before applying.  
- If your launch template already defines network interfaces, review the security group configuration because vpc_security_group_ids cannot be combined with a network_interfaces configuration in the same launch template.  
