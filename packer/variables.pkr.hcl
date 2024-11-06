variable "project_name" {
  type        = string
  description = "The name of the application"
}

variable "project_environment" {
  type        = string
  description = "The environment where the application is deployed"
}

variable "source_ami_id" {
  type        = string
  description = "The AMI ID for the base image used to create the temporary instance"
}

variable "source_instance_type" {
  type        = string
  description = "The type of EC2 instance used for building the image"
}

variable "git_commit_id" {
  type        = string
  description = "The unique identifier (SHA) of the Git commit associated with this build or deployment"
}


locals {
  build_timestamp = "${formatdate("DD-MM-YYYY-hh-mm", timestamp())}"
  full_image_name = "${var.project_name}-${var.project_environment}-${local.build_timestamp}"
}
