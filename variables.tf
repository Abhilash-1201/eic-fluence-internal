variable "region_name" {
  description = "The AWS region where resources will be provisioned"
  type        = string
  default     = "us-east-2" # Default region if not provided
}

variable "ami_id" {
  description = "The AMI ID for the jump server instance"
  type        = string
  default     = "ami-0b8b44ec9a8f90422"
}

variable "instance_type" {
  description = "The instance type for the jump server"
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
  default     = "einfochips"
}

variable "subnet_id" {
  description = "The subnet ID where the instance will be launched"
  type        = string
  default     = "subnet-c7d63abc"
}

variable "vpc_security_group_id" {
  description = "The ID of the security group for the jump server"
  type        = string
  default     = "vpc-54e5273d"
}

variable "availability_zone" {
  description = "The availability zone for the instance"
  type        = string
  default     = "us-east-2b"
}

variable "volume_size" {
  description = "The size of the root volume for the instance (in GB)"
  type        = number
  default     = 50
}

variable "volume_type" {
  description = "The type of the root volume for the instance"
  type        = string
  default     = "gp3"
}
