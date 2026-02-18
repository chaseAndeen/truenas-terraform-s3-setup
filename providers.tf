terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "sysop"
  
  default_tags {
    tags = {
      Project   = "NAS-Disaster-Recovery"
      ManagedBy = "Terraform"
    }
  }
}