variable "region" { type = string }
variable "environment" { type = string }
variable "vpc_cidr" { type = string }
variable "public_subnet_cidr" { type = string }
variable "private_subnet_cidr" { type = string }
variable "admin_cidr" { type = string }
variable "instance_type" { type = string }
variable "health_check_cron" { type = string }
