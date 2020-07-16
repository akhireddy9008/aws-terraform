variable "workspace_to_environment_map" {
  type = map
  default = {
    dev   = "dev"
    qa    = "qa"
    stage = "stage"
    prod  = "prod"
  }
}
variable region {}
#Backend Variables
variable s3_bucket_state_file {}
variable backend_dynamodb_table {}

#VPC  Variables

variable "vpc_cidr" { }
variable "sub_private_cidr_1" {
}
variable "sub_private_cidr_2" {}

variable "sub_public_cidr_1" {}
variable "sub_public_cidr_2" {
}

#bastion host variables
variable "ami" {}

variable "key_name" {}

variable "public_key" {}

variable "instance_type" { 
}
#eks variables
variable "ami_type" {
  
}

#rds variables

variable "rds_name" {}
variable "rds_username" {}
variable "rds_db_sub_group_name" {}
variable "rds_db_sg" {}

#vpc end point variable
variable "endpoint_service" {
  
}
