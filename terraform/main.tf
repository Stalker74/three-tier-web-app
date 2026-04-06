terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
    }
  }
  backend "s3" {
    bucket = "175200623112-terraform-state"
    key    = "eks-project/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}


data "aws_caller_identity" "current" {}

module "vpc" {
  source       = "./modules/vpc"
  vpc_name     = var.vpc_name
  cluster_name = var.cluster_name
}

module "eks" {
  source             = "./modules/eks"
  cluster_name       = var.cluster_name
  cluster_role_arn   = module.iam.cluster_role_arn
  node_role_arn      = module.iam.node_role_arn
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "iam" {
  source            = "./modules/iam"
  cluster_name      = var.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider     = module.eks.oidc_provider
  account_id        = data.aws_caller_identity.current.account_id
}

module "vpn" {
  source                = "./modules/vpn"
  server_cert_arn       = var.server_cert_arn
  client_cert_arn       = var.client_cert_arn
  private_subnet_id_1a  = module.vpc.private_subnet_ids[0]
  private_subnet_id_1b  = module.vpc.private_subnet_ids[1]
}

