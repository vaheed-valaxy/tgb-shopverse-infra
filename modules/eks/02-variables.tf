variable project    { type = string }

variable env        { type = string }

#############################################             Cluster Variables            #################################################

variable "cluster_name"                  { type = string }

variable cluster_version                 { type = string }

variable cluster_subnet_ids              { type = list(string) }

variable cluster_endpoint_private_access { type = bool }

variable cluster_endpoint_public_access { type = bool }

# variable cluster_addl_security_group_ids { type = list(string) }    # For Cluster to Node and vice versa communication


#############################################             Node Group Variables           #################################################

variable node_subnet_ids     { type = list(string) }

variable node_instance_types { type = list(string) }

variable node_capacity_type  { type = string }  # ON_DEMAND/ SPOT

variable "node_disk_size" {
  type        = number
  description = "Disk size (in GB) for EKS worker nodes"
  default     = 20  # minimum 20 GB

  validation {
    condition     = var.node_disk_size >= 8 && var.node_disk_size <= 30
    error_message = "Disk size must be between 8GB and 30GB."
  }
}
# variable "node_ssh_public_key" { type = string }

variable "enable_bastion_access" { default = null }
variable "bastion_sg_id"         { default = null }


variable "desired_capacity" { type = number }
variable "min_size"         { type = number }
variable "max_size"         { type = number }

variable "node_auto_scaler_tags" { default = {} }

############################################     Variables for Tagging subnets for ELB    #######################################################################
# variable "public_subnet_ids"  { type = list(string) }
# variable "private_subnet_ids" { type = list(string) }

  
