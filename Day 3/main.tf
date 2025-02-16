terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.86.1"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

# Call VPC module
module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["us-west-2a", "us-west-2b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  environment          = "training"
  name = "training-vpc"
  tags = {Owner = "Kamesh"}
  project = "my-terraform-project"
}

# module "vpc_virginia" {
#   source               = "./modules/vpc"
#   vpc_cidr             = "10.0.0.0/16"
#   availability_zones   = ["us-west-2a", "us-west-2b"]
#   public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
#   private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
#   environment          = "training"
#   name = "training-vpc"
#   tags = {Owner = "Kamesh"}
#   project = "my-terraform-project"
#   providers = {
#     aws = aws.virginia
#   }
# }

# Call EC2 module
module "ec2" {
  source               = "./modules/ec2"
  name                 = "kamesh-terraform"
  vpc_id               = module.vpc.vpc_id
  subnet_id            = module.vpc.public_subnet_ids[0]
  instance_type        = "t2.micro"
  instance_count       = 1
  key_name             = "kamesh"
  ssh_private_key_path = "${path.module}/kamesh.pem"
  environment          = "training"
  project              = "my-awesome-project"
  tags = {
    Owner = "Kamesh"
  }
}

# module "ec2_virginia" {
#   source               = "./modules/ec2"
#   name                 = "kamesh-terraform"
#   vpc_id               = module.vpc.vpc_id
#   subnet_id            = module.vpc.public_subnet_ids[0]
#   instance_type        = "t2.micro"
#   instance_count       = 1
#   key_name             = "kamesh"
#   ssh_private_key_path = "${path.module}/kamesh.pem"
#   environment          = "training"
#   project              = "my-awesome-project"
#   tags = {
#     Owner = "Kamesh"
#   }
#   providers = {
#     aws = aws.virginia
#   }
# }
