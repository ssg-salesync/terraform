variable "region" {
  description = "AWS Region"
}

variable "vpc_name" {
  description = "VPC Name"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
}

variable "db_password" {
  description = "DB Password"
}

variable "private_key_path" {
  description = "Private Key Path"
}

variable "desired_size" {
  description = "Desired Size"
}

variable "max_size" {
  description = "Max Size"
}

variable "min_size" {
  description = "Min Size"
}