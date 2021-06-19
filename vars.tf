#####example1###
variable "region" {}
variable "main_vpc_cidr" {}
variable "public_subnets" {}
variable "private_subnets" {}
####example2
variable "vpc_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}
variable "vpc_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}