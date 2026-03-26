output "access_key_id" {
  description = "IAM access key ID for TrueNAS S3 sync"
  value       = aws_iam_access_key.truenas_keys.id
}

output "secret_access_key" {
  description = "IAM secret access key for TrueNAS S3 sync"
  value       = aws_iam_access_key.truenas_keys.secret
  sensitive   = true
}

output "bucket_name" {
  description = "S3 bucket name"
  value       = aws_s3_bucket.nas_backups.id
}

output "bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.nas_backups.arn
}

output "bucket_domain_name" {
  description = "S3 bucket domain name"
  value       = aws_s3_bucket.nas_backups.bucket_domain_name
}
