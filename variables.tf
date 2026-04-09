variable "aws_profile" {
  description = "AWS CLI profile for S3 resource provisioning"
  type        = string
  default     = "InfraProvisioner"
}

variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
  default     = "kernelstack-infra-backups"
}

variable "iam_user_name" {
  description = "IAM user name for TrueNAS S3 sync"
  type        = string
  default     = "truenas-s3-sync-user"
}

variable "archive_days" {
  description = "Days before transitioning objects to S3 Glacier Deep Archive"
  type        = number
  default     = 1
}

variable "iam_admin_profile" {
  description = "AWS profile with IAM write permissions for creating the TrueNAS sync user and access key. InfraProvisioner lacks iam:* so a separate admin profile is required."
  type        = string
  default     = "AdministratorAccess"
}
