variable "primary_region" {
  type = string
  default = "us-east-1"
}

variable "secondary_region" {
  type = string
  default = "us-west-2"
}

variable "azs_primary" {
  type = list(string)
}

variable "azs_secondary" {
  type = list(string)
}

variable "vpc_cidr_primary" {
  type = string
}

variable "vpc_cidr_secondary" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "app_bucket" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "sns_email" {
  type = string
}