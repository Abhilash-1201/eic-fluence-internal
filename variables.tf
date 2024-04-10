
variable "aws_auth_users" {
  description = "List of user maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}
########################eks###########################

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

variable "service_ipv4_cidr" {
  type        = string
  description = "The CIDR block to assign Kubernetes pod and service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the 10.100.0.0/16 or 172.20.0.0/16 CIDR blocks."
}

variable "node_group_name" {
  type        = string
  description = "Name of the EKS Node Group"
}

variable "node_instance_types" {
  type        = string
  description = "Instance types to use for this node group (up to 20)."
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


variable "vpc_id" {
  type        = string
  description = "VPC ID for the security group"
}

variable "sg_name" {
  type        = string
  description = "Security group name"
}

variable "region_name" {
  type        = string
  description = "region name for deploying these services"
}


variable "tags" {
  description = "A map of tags for VPC resources"
  type        = map(string)
}
############ ecr #################################
variable "images_names" {
  type        = list(string)
  description = "List of Docker local image names, used as repository names for AWS ECR "
}
