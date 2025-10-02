variable "primary_region" {
  type = string
}

variable "secondary_region" {
  type = string
}

variable "primary_vpc_id" {
  type = string
}

variable "primary_subnets" {
  type = list(string)
}

variable "primary_db_sg_id" {
  type = string
}

variable "secondary_vpc_id" {
  type = string
}

variable "secondary_subnets" {
  type = list(string)
}

variable "secondary_db_sg_id" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}