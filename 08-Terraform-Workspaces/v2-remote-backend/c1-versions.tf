# Terraform Block
terraform {
  required_version = ">= 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "terraform-stacksimplify-obi"
    key    = "terraform.tfstate"
    region = "eu-west-1"
    # For State Locking
    dynamodb_table = "terraform-dev-state-table"
  }



}


# Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "default"
}
/*
Note-1:  AWS Credentials Profile (profile = "default") configured on your local desktop terminal  
$HOME/.aws/credentials
*/
