variable project    { type = string }
variable env        { type = string }

#############################################             Cluster Variables            #################################################

variable "vpc_id"                          { type = string }
variable "cluster_name"                    { type = string }
variable "cluster_version"                 { type = string }
variable "cluster_subnet_ids"              { type = list(string) }
variable "cluster_endpoint_private_access" { type = bool }
variable "cluster_endpoint_public_access"  { type = bool }

# variable cluster_addl_security_group_ids { type = list(string) }    # For Cluster to Node and vice versa communication


#############################################             Node Group Variables           #################################################

variable "node_ssh_key_name"       { default = null }
variable "node_subnet_ids"         { type = list(string) }

variable "app_node_capacity_type"  { type = string }   # ON_DEMAND / SPOT
variable "ci_node_capacity_type"   { type = string }   # ON_DEMAND / SPOT

variable "app_node_instance_types" { type = list(string) }
variable "ci_node_instance_types"  { default = [] }

variable "node_disk_size" {
  type        = number
  description = "Disk size (in GB) for EKS worker nodes"
  default     = 20  # minimum 20 GB

  validation {
    condition     = var.node_disk_size >= 8 && var.node_disk_size <= 30
    error_message = "Disk size must be between 8GB and 30GB."
  }
}

# type = bool
variable "enable_bastion_access_to_cluster"        { default = false }
variable "enable_app_node_ssh_access_from_bastion" { default = false }
variable "enable_ci_node_ssh_access_from_bastion"  { default = false } 

variable "bastion_sg_id" { default = null }

variable "app_node_min_size"         { type = number }
variable "app_node_max_size"         { type = number }
variable "app_node_desired_capacity" { type = number }

variable "ci_node_min_size"         { default = 0 }
variable "ci_node_max_size"         { default = 3 }
variable "ci_node_desired_capacity" { default = 1 }

variable "node_auto_scaler_tags"    { default = {} }

############################################     Variables for Tagging subnets for ELB    #######################################################################
# variable "public_subnet_ids"  { type = list(string) }
# variable "private_subnet_ids" { type = list(string) }
