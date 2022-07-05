# -------------------------------------------------------------- Variables --- #

variable "aws_region" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "subdomain_name" {
  type    = string
  default = ""
}

variable "default_document" {
  type    = string
  default = "index.html"
}