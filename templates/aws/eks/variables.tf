# variable "vpc_id" {
#   type = string
# }

# variable "public_subnet_ids" {
#   type = list(string)
# }

# variable "private_subnet_ids" {
#   type = list(string)
# }

# variable "cluster_name" {
#   type    = string
#   default = "temp"
# }

# variable "kubernets_version" {
#   type = string
# }

# variable "tags" {
#   type    = map(string)
#   default = {}
# }

# variable "on_demand_instance_types" {
#   type    = list(string)
#   default = ["t3.small"]
# }

# variable "spot_instance_types" {
#   type    = list(string)
#   default = ["t3.small"]
# }


# variable "r53_subzone_name" {
#   type    = string
#   default = ""
# }

# variable "r53_hosted_zone_name" {
#   type    = string
#   default = ""
# }

# variable "worker_nodes_kms_key_aliases" {
#   type    = list(string)
#   default = []
# }

# variable "additional_policies" {
#   type        = map(string)
#   description = "Additional policies to be added to the IAM role."
# }

# variable "fargate_profile_namespace" {
#   type        = string
#   description = "Namespace to be used by the Fargate Profile."
# }
# variable "fargate_profile_name" {
#   type        = string
#   description = "Name of the Fargate Profile."
# }

# variable "create_fargate_profile" {
#   type        = bool
#   description = "Whether to create a Fargate Profile."
# }


############################################################################################


############################################################################################
#EKS 

variable "vpc_id" {
  type    = string
  default = "value"
}

variable "public_subnet_ids" {
  type    = list(string)
  default = []
}

variable "private_subnet_ids" {
  type    = list(string)
  default = []
}

variable "cluster_name" {
  type    = string
  default = "value"
}

variable "kubernets_version" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "node_security_group_tags" {
  type    = map(string)
  default = {}
}

# variable "on_demand_instance_types" {
#   type    = list(string)
#   default = ["t3.small"]
# }

# variable "spot_instance_types" {
#   type    = list(string)
#   default = ["t3.small"]
# }


variable "r53_subzone_name" {
  type    = string
  default = ""
}

variable "r53_hosted_zone_name" {
  type    = string
  default = ""
}

variable "worker_nodes_kms_key_aliases" {
  type    = list(string)
  default = []
}

# variable "additional_policies" {
#   type        = map(string)
#   description = "Additional policies to be added to the IAM role."
# }

# variable "fargate_profile_namespace" {
#   type        = string
#   description = "Namespace to be used by the Fargate Profile."
# }
# variable "fargate_profile_name" {
#   type        = string
#   description = "Name of the Fargate Profile."
# }

variable "create_fargate_profile" {
  type        = bool
  description = "Whether to create a Fargate Profile."
  default     = false
}

variable "fargate_profiles" {
  type = map(object({
    name          = string
    namespace     = string
    iam_role_name = string
    selectors = list(object({
      namespace = string
      labels    = map(string)
    }))
    additional_policies = map(string)
  }))
  description = "Map of Fargate profiles to create."
  default     = {}
}

# eks eks ############################################################################################################


# variable "resource_prefix" {
#   type        = string
#   description = "Prefix to be used on each infrastructure object Name created in AWS."
# }

# variable "environment" {
#   type        = string
#   description = "Environment name."
# }

# variable "app_name" {
#   type        = string
#   description = "Name of the application."
# }

# create some variables
variable "nodegroup_subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the EKS Node Group."
  default     = []
}


variable "developer_roles" {
  type        = list(string)
  description = "List of Kubernetes developer roles."
  default     = []
}


variable "developer_users" {
  type        = list(string)
  description = "List of Kubernetes developers."
  default     = []
}

variable "developer_user_group" {
  type        = string
  description = "Name of the kube group for developers."
  default     = "value"
}

variable "kubernetes_groups" {
  type        = string
  description = "Name of the Kubernetes group."
  default     = "value"
}


variable "oic_role_configurations" {
  description = "values for the OIDC role configurations."
  type = map(object({
    role_name           = string
    assume_role_actions = list(string)
    namespace           = string
    service_account     = string
    policy_file         = string
  }))
  default = {
    "name" = {
      role_name           = "value"
      assume_role_actions = ["value"]
      namespace           = "value"
      service_account     = "value"
      policy_file         = "value"
    }
  }
}

variable "cluster_additional_security_group_ids" {
  type        = list(string)
  description = "List of additional security group IDs to attach to the EKS cluster."
  default     = []
}

variable "enable_creation_role_with_oidc" {
  type        = bool
  description = "Enable creation of IAM roles with OIDC."
  default     = false
}


############################################################################################



# Node Group
# variable "create_node_security_group" {
#   type        = bool
#   description = "Whether to create a security group for the node group."
#   default = false
# }

variable "iam_node_group_role" {
  type        = string
  description = "The name of the IAM role to attach to the EKS managed node group."
  default     = "value"
}


variable "create_managed_node_groups" {
  type        = bool
  description = "Whether to create a managed node group."
  default     = false
}

# variable "ami_type" {
#   type        = string
#   description = "The type of AMI to use for the EKS managed node group."
# }

# variable "min_size" {
#   type        = number
#   description = "Minimum number of nodes in the EKS managed node group."
# }

# variable "max_size" {
#   type        = number
#   description = "Maximum number of nodes in the EKS managed node group."
# }
# variable "desired_size" {
#   type        = number
#   description = "Desired number of nodes in the EKS managed node group."
# }
# variable "instance_types" {
#   type        = list(string)
#   description = "List of instance types to use for the EKS managed node group."
# }

# variable "capacity_type" {
#   type        = string
#   description = "Capacity type for the EKS managed node group."
# }

# variable "network_interfaces" {
#   type = list(object({
#     associate_public_ip_address = bool
#     delete_on_termination       = bool
#   }))
#   description = "List of network interfaces to attach to the EKS managed node group."
# }

variable "eks_managed_node_groups" {
  description = "values for the EKS managed node groups."
  type = map(object({
    ami_type       = string
    min_size       = number
    max_size       = number
    desired_size   = number
    instance_types = list(string)
    capacity_type  = string
    # use_custom_launch_template = bool
    # disk_size                  = number
    network_interfaces = list(object({
      delete_on_termination       = bool
      associate_public_ip_address = bool
    }))
  }))
  default = {
    "name" = {
      ami_type       = "value"
      capacity_type  = "value"
      desired_size   = 0
      instance_types = ["value"]
      max_size       = 0
      min_size       = 0
      network_interfaces = [{
        associate_public_ip_address = false
        delete_on_termination       = false
      }]
    }
  }
}

# variable "eks_managed_node_groups" {}
variable "ebs_kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key to use for EBS encryption."
  default     = "temp"
}

variable "tag_specifications" {
  type        = list(string)
  description = "List of tag specifications to apply to the EKS managed node group."
  default     = []
}

# variable "subnet_ids" {
#   type        = list(string)
#   description = "List of subnet IDs to launch the EKS managed node group in."
# }

# variable "cluster_version" {
#   type        = string
#   description = "The Kubernetes server version for the EKS cluster."
#   default     = "value"
# }

variable "autoscaling_average_cpu" {
  type        = number
  description = "Average CPU threshold to autoscale EKS EC2 instances."
  default     = 0
}

variable "cluster_service_cidr" {
  type        = string
  description = "CIDR block for the EKS cluster service."
  default     = "value"
}


variable "iam_role_nodes_additional_policies" {
  type        = map(string)
  description = "List of additional IAM policies to attach to EKS managed node groups."
  default     = {}
}

variable "cluster_primary_security_group_id" {
  type        = string
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
  default     = "value"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to attach to the EKS cluster."
  default     = []
}

variable "node_add_policy_name" {
  type        = string
  description = "Name of the policy to attach to the EKS managed node group."
  default     = "value"
}
