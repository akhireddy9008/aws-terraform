provider "aws" {
  version = "~> 2.0"
  region  = var.region
 # profile = var.aws_profile
}

locals {
  environment = lookup(var.workspace_to_environment_map, terraform.workspace, "dev")
}


#Comment below code for Backend on 1st terraform apply
#Backend Configuration to store State files remotely on S3
# #Backend code starts here
 terraform {
   backend "s3" {
     encrypt        = true
     bucket         = "s3-terraform-state-kubernetes"
     dynamodb_table = "dynamodb-terraform-state-kubernetes"
     region         = "us-west-2"
     key            = "terraform.tfstate"
    
   }
 }

#Module to create S3 bucket and dynamo DB for backend config

# module "backend" {
#   source                 = "./module/backend"
#   s3_bucket_state_file   = var.s3_bucket_state_file
#   backend_dynamodb_table = var.backend_dynamodb_table

# }


#VPC Module

module "vpc_network" {
  source             = "./module/vpc_network"
  vpc_cidr           = var.vpc_cidr
  sub_private_cidr_1 = var.sub_private_cidr_1
  sub_private_cidr_2 = var.sub_private_cidr_2
  sub_public_cidr_1  = var.sub_public_cidr_1
  sub_public_cidr_2  = var.sub_public_cidr_2
}

#EKS MODULE

module "eks_cluster" {
  source             = "./module/eks_cluster"
  vpc_id             = module.vpc_network.vpc_id
  subnet_ids         = ["${module.vpc_network.subnet_id_1}", "${module.vpc_network.subnet_id_2}"]
  source_security_group_id = module.bastion_host.source_security_group_id
  ami_type           =  var.ami_type
}

#RDS Module

module "rds_db" {
  source             = "./module/rds_db"
  environment           = terraform.workspace
  rds_name              = "${var.rds_name}-${terraform.workspace}"
  rds_username          = var.rds_username
  rds_db_sub_group_name = "${var.rds_db_sub_group_name}-${terraform.workspace}"
  rds_db_sub_group_ids  = ["${module.vpc_network.subnet_id_1}", "${module.vpc_network.subnet_id_2}"]
  rds_db_sg             = var.rds_db_sg
  rds_db_sg_ingres_cidr = "${terraform.workspace == "prod" ? "${var.vpc_cidr}" : "0.0.0.0/0"}"
  rds_db_sg_vpc_id      = module.vpc_network.vpc_id

}


# VPC ENDPOINT


module "vpc_end_point" {
  source             = "./module/vpc_end_point"
  vpc_id             = module.vpc_network.vpc_id
  endpoint_service   = var.endpoint_service
  vpc_route_table     = module.vpc_network.vpc_route_table
 
}




# bastion host
module "bastion_host" {
  source             = "./module/bastion_host"
  ami                = var.ami
  subnet_id          = module.vpc_network.subnet_id_4
  key_name           = var.key_name
  vpc_id              = module.vpc_network.vpc_id
  public_key         = var.public_key
  instance_type      = var.instance_type
}






