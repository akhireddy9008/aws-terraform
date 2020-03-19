variable "environment" {}
variable "rds_name" {}
variable "rds_username" {}
#variable "rds_password" {}

variable "rds_db_sub_group_name" {}

variable "rds_db_sub_group_ids" {}

variable "rds_db_sg" {}

variable "rds_db_sg_ingres_cidr" {}
variable "rds_db_sg_vpc_id" {}
variable "keeper" {
  default = "1"
}