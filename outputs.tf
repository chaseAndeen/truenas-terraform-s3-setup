output "access_key" {
  value = aws_iam_access_key.truenas_keys.id
}

output "secret_key" {
  value     = aws_iam_access_key.truenas_keys.secret
  sensitive = true
}

output "s3_bucket_domain" {
  value = aws_s3_bucket.nas_backups.bucket_domain_name
}