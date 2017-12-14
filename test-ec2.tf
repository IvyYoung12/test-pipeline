variable "name"    {}
variable "count"   {}
variable "instance_type" {}
variable "ami"     {}
variable "subnet_id" {}
variable "vpc_security_group_ids" {type="list"}
variable "region"  {}
variable "profile" {}
# variable "tags"                   {type="map"}


provider "aws" {
  region = "${var.region}"
  profile = "${var.profile}"
}

# resource "aws_dynamodb_table" "terraform_statelock" {
#   name           = "terraform_statelock"
#   read_capacity  = 20
#   write_capacity = 20
#   hash_key       = "LockId"

#   attribute {
#     name = "LockId"
#     type = "S"
#   }
# }

terraform {
  backend "s3" {
    bucket         = "playgrd-terraform-remote-state-storage"
    key            = "Component2/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table     = "terraform_statelock"
  }
}

module "ec2_cluster" {
  source = "terraform-aws-modules/ec2-instance/aws"
  name  = "${var.name}"
  count = "${var.count}"
  
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = "${var.vpc_security_group_ids}"
  subnet_id              = "${var.subnet_id}"

  # tags =                 = "${var.tags}"
    
  }