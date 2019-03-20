variable "subnet_ids" {
  type = "list"
}

variable "region" {
  default = ""
}

variable "ami" {
  type = "string"
}

variable "name" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "count" {
  default = 0
}

variable "route53_zone_id" {
  type = "string"
}
