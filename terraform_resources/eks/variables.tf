variable "aws_auth_users" {
  description = "List of user maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}
variable "region_name" {
  description = "AWS Region Id"
}

#################### SG VARIABLES ##################
variable "vpc_id" {
  type        = string
  description = "VPC ID for the security group"
}


#################### MASTER VARIABLES ##############
variable "cluster_name" {
    type        = string
    description = "Name of the cluster."
}

variable "cluster_version" {
    type        = string
    description = "Desired Kubernetes master version. If you do not specify a value, the latest available version is used"
}


variable "subnet_ids" {
    type        = list(string)
    description = "List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane"
}

variable "cluster_endpoint_private_access" {
  type        = bool
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled. Default to AWS EKS resource and it is false"
  default     = false
}

variable "cluster_endpoint_public_access" {
  type        = bool
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. Default to AWS EKS resource and it is true"
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  type        = list(string)
  description = "Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0."
  default     = ["0.0.0.0/0"]
}

variable "ip_family" {
    type        = string
    description = "The IP family used to assign Kubernetes pod and service addresses."
    default     = "ipv4"
}

variable "service_ipv4_cidr" {
    type        = string
    description = "The CIDR block to assign Kubernetes pod and service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the 10.100.0.0/16 or 172.20.0.0/16 CIDR blocks."
}

variable "cluster_enabled_log_types" {
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  type        = list
  description = "Enable EKS CWL for EKS components"
}

variable "tags" {
    type        = map(string)
    description = "A map of tags for eks cluster"
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain log events. Default retention - 90 days"
  type        = number
  default     = 90
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "If a KMS Key ARN is set, this key will be used to encrypt the corresponding log group. Please be sure that the KMS Key has an appropriate key policy (https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html)"
  type        = string
  default     = null
}

########################### NODE VARIABLES ###################################
variable "node_group_name" {
    type        = string
    description = "Name of the EKS Node Group"
}

variable "node_instance_types" {
    type        = string
    description = "Instance types to use for this node group (up to 20)."
}

variable "node_capacity_type" {
    type        = string
    description = "Type of capacity associated with the EKS Node Group. Valid values: 'ON_DEMAND', 'SPOT', or `null`."
    default     = "ON_DEMAND"
}


variable "desired_size" {
    type        = number
    description = "Desired number of worker nodes."
}

variable "max_size" {
    type        = number
    description = "Maximum number of worker nodes."
}

variable "min_size" {
    type        = number
    description = "Manimum number of worker nodes."
}

variable "launch_template_name" {
    type        = string
    description = "The name of the launch template."
}

variable "key_name" {
    type        = string
    description = "The key name to use for the instance."
}

variable "volume_size" {
    type        = number
    description = "The size of the volume in gigabytes."
}

variable "volume_type" {
    type        = string
    description = " The volume type. Can be standard, gp2, gp3, io1, io2, sc1 or st1 (Default: gp2)."
    default     = "gp2"
}
