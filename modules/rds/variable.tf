variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}


variable "db_name" {
  description = "The name of the database"
  default     = "salesync"
  type        = string
}


variable "sg_id" {}


variable "db_username" {
  default = "postgres"
}


variable "subnet_ids" {
  type = list(string)
}