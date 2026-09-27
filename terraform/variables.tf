variable "aws_region" {
  description = "AWS region where the infrastructure will be created."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for resource naming and tagging."
  type        = string
  default     = "globallyhub-devops"
}

variable "environment" {
  description = "Environment name for infrastructure tagging."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the Kubernetes VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones used by the Kubernetes nodes."
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "subnet_cidrs" {
  description = "CIDR blocks for the three public Kubernetes subnets."
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]

  validation {
    condition     = length(var.subnet_cidrs) == 3
    error_message = "Exactly three subnet CIDRs are required."
  }
}

variable "instance_type" {
  description = "EC2 instance type for all Kubernetes nodes."
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "Existing AWS EC2 key pair name used for SSH access."
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to SSH to Kubernetes nodes."
  type        = string

  validation {
    condition     = can(cidrhost(var.ssh_allowed_cidr, 0))
    error_message = "ssh_allowed_cidr must be a valid CIDR block, for example 203.0.113.10/32."
  }
}

variable "kubernetes_api_allowed_cidr" {
  description = "CIDR allowed to access the Kubernetes API."
  type        = string

  validation {
    condition     = can(cidrhost(var.kubernetes_api_allowed_cidr, 0))
    error_message = "kubernetes_api_allowed_cidr must be a valid CIDR block."
  }
}

variable "ubuntu_ami_id" {
  description = "Optional Ubuntu 24.04 LTS AMI ID. Leave empty to discover the latest official Canonical image."
  type        = string
  default     = ""
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 30
}