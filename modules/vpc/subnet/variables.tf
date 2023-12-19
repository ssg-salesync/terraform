variable "az" {
  description = "The availability zone"
}


variable "index" {
  description = "The index of the instance"
}


variable "vpc_id" {
  description = "The ID of the VPC"
}


variable "vpc_cidr" {
  description = "The CIDR of the VPC"
}


variable "public_ip" {
  description = "Whether to create a public IP"
  type        = bool
  default     = false
}