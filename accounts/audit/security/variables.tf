# Global variables
variable "project_name" {
  description = "Project name."
}

variable "aws_region" {
  description = "Main region for all accounts and resources."
}

variable "project_owner" {
  description = "Project owner."
}

variable "accounts" {
  description = " List of Organization Accounts and additional information."
}

variable "cidr_blocks" {
  description = " CIDR Blocks for the VPC networks."
}

# Environment specific variables
