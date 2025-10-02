variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "alb_tg_arn" {
  type = string
}

variable "ec2_sg_id" {
  type = string
}

variable "instance_role" {
  type = string
}

variable "app_bucket" {
  type = string
}

variable "db_endpoint" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}