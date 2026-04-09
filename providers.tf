terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Default provider — used for S3 resources.
# The default profile needs s3:* but no IAM permissions.
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project   = "NAS-Disaster-Recovery"
      ManagedBy = "Terraform"
    }
  }
}

# IAM provider — used for the TrueNAS sync user and access key.
# A separate profile is required because InfraProvisioner lacks iam:* permissions.
# Set var.iam_admin_profile to an AWS profile with IAM write access
# (e.g. AdministratorAccess or a role with iam:CreateUser, iam:CreateAccessKey).
provider "aws" {
  alias   = "iam_admin"
  region  = var.aws_region
  profile = var.iam_admin_profile

  default_tags {
    tags = {
      Project   = "NAS-Disaster-Recovery"
      ManagedBy = "Terraform"
    }
  }
}
