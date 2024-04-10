variable "image_names" {
    type        = list(string)
    description = "List of Docker local image names, used as repository names for AWS ECR "
}

variable "image_tag_mutability" {
  type        = string
  default     = "IMMUTABLE"
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`"
}

variable "force_delete" {
  type        = bool
  description = "Whether to delete the repository even if it contains images"
  default     = false
}

variable "scan_images_on_push" {
  type        = bool
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not (false)"
  default     = true
}

variable "tags" {
    description = "A map of tags for VPC resources"
    type        = map(string)
}

variable "encryption_type" {
    description = "ECR encryption configuration"
    type        = string
    default     = "AES256"
}