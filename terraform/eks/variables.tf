# BEGIN variables

variable "credentials" {
 description = "path to the aws credentials file"
 default = "~/.aws/credentials"
 type    = string
}

variable "profile" {
 description = "name of the aws config profile"
 default = "default"
 type    = string
}

variable "cluster_name" {
  description = "unique name of the eks cluster"
  type    = string
}

variable "k8s_version" {
  description = "kubernetes version"
  default = "1.28"
  type    = string
}

variable "region" {
 description = "name of aws region to use"
 type    = string
}

variable "azs" {
 description = "list of aws availabilty zones in aws region"
 type = list
}


variable "cidr_vpc" {
 description = "RFC 1918 CIDR range for EKS cluster VPC"
 default = "192.168.0.0/16"
 type    = string
}

variable "cidr_private" {
 description = "RFC 1918 CIDR range list for EKS cluster VPC subnets"
 default = ["192.168.64.0/18", "192.168.128.0/18", "192.168.192.0/18"]
 type    = list 
}

variable "cidr_public" {
 description = "RFC 1918 CIDR range list for EKS cluster VPC subnets"
 default = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"]
 type    = list 
}

variable "efs_performance_mode" {
   default = "generalPurpose"
   type = string
}

variable "efs_throughput_mode" {
   description = "EFS performance mode"
   default = "bursting"
   type = string
}

variable "import_path" {
  description = "fsx for lustre s3 import path"
  type = string
  default = ""
}

variable "key_pair" {
  description = "Name of EC2 key pair used to launch EKS cluster worker node EC2 instances"
  type = string
  default = ""
}

variable "node_volume_size" {
  description = "Node disk size in GB"
  type = number
  default = 200
}

variable "node_group_desired" {
    description = "Node group desired size"
    default = 0
    type = number
}

variable "node_group_max" {
    description = "Node group maximum size"
    default = 32
    type = number
}

variable "node_group_min" {
    description = "Node group minimum size"
    default = 0
    type = number
}

variable "capacity_type" {
  description = "ON_DEMAND or SPOT capacity"
  default = "ON_DEMAND"
  type = string
}

variable "kubeflow_namespace" {
  description = "Kubeflow namespace"
  default = "kubeflow"
  type = string
}

variable "efa_enabled" {
  description = "Map of EFA enabled instance type to number of network interfaces"
  type = map(number)
  default = {
    "p4d.24xlarge" = 4
    "p4de.24xlarge" = 4
    "p5.48xlarge" = 32
    "trn1.32xlarge" = 8
    "trn1n.32xlarge" = 8
  }
}

variable "node_instances" {
  description = "List of instance types for accelerator node groups. Ignored if karpenter_enabled=true."
  type = list(string)
  default = ["g5.xlarge", "p3.16xlarge", "p3dn.24xlarge"]
}

variable "system_instances" {
  description = "List of instance types for system nodes."
  type = list(string)
  default = [
    "m7a.large", 
    "m7a.xlarge", 
    "m7a.2xlarge", 
    "m7a.4xlarge", 
    "m7a.8xlarge"
  ]
}

variable "system_volume_size" {
  description = "System node volume size in GB"
  type = number
  default = 200
}

variable "neuron_instances" {
  description = "Neuron instances"
  type = list(string)
  default = [
    "inf2.xlarge",
    "inf2.8xlarge",
    "inf2.24xlarge",
    "inf2.48xlarge",
    "trn1.32xlarge",
    "trn1n.32xlarge"
  ]
}

variable "custom_taints" {
  description = "List of custom taints applied to node groups.  Ignored if karpenter_enabled=true"
  type = list(object({
    key = string
    value = string
    effect = string
  }))
  default = []
}

variable "karpenter_enabled" {
  description = "Karpenter enabled"
  type = bool
  default = true
}

variable "karpenter_namespace" {
  description = "Karpenter name space"
  type = string
  default = "kube-system"
}

variable "karpenter_version" {
  description = "Karpenter version"
  type = string
  default = "v0.33.0"
}

variable "karpenter_capacity_type" {
  description = "Karpenter capacity type: 'on-demand' or 'spot'"
  type = string
  default = "on-demand"
}

variable "karpenter_consolidate_after" {
  description = "Karpenter consolidate-after delay"
  type = string
  default = "600s"
}
variable "nvidia_plugin_version" {
  description = "NVIDIA Device Plugin Version"
  type = string
  default = "v0.14.3"
}

variable "local_helm_repo" {
  description = "Local Helm charts path"
  type        = string
  default     = "../../../charts"
}

variable "tags" {
  description = "Tags"
  type        = map
  default     = {}
}

# END variables
