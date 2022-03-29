terraform {
  required_version = ">= 1.1.2"

   required_providers {
    aws = {
      version = ">= 4.8.0"
      source = "hashicorp/aws"
    }
  }

}

provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region     = var.AWS_DEFAULT_REGION
}