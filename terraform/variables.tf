variable "project_name" {
  type        = string
  description = "project name"
}

variable "project_environment" {
  type        = string
  description = "project environment "
}


variable "ec2_type" {
  type        = string
  description = "Ec2 type"
}

variable "default_vpc_id" {
  type        = string
  description = "default vpc id"
}

variable "frontend_ports" {
  type        = list(string)
  description = "frontend ports"
}

variable "domain_name" {
  type        = string
  description = "domain name"
}

variable "hostname" {
  type        = string
  description = "hostname"
}

