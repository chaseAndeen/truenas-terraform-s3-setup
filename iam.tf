# Create the User
resource "aws_iam_user" "truenas_user" {
  name = var.iam_user_name
}

# Generate Keys
resource "aws_iam_access_key" "truenas_keys" {
  user = aws_iam_user.truenas_user.name
}

# Attach Least-Privilege Policy
resource "aws_iam_user_policy" "truenas_s3_policy" {
  name = "TrueNAS-S3-Sync-Policy"
  user = aws_iam_user.truenas_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketVersioning"
        ]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.nas_backups.arn,
          "${aws_s3_bucket.nas_backups.arn}/*"
        ]
      }
    ]
  })
}