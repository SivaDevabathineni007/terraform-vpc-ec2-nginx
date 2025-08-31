variable "name" {
  type    = string
  default = "iac-challenge"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "az_count" {
  type    = number
  default = 3
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "enable_nginx" {
  type    = bool
  default = false
}

