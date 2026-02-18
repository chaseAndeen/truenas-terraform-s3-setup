resource "aws_s3_bucket" "nas_backups" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "nas_versioning" {
  bucket = aws_s3_bucket.nas_backups.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "nas_lifecycle" {
  bucket = aws_s3_bucket.nas_backups.id

  rule {
    id     = "archive-to-deep-archive"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = var.archive_days
      storage_class = "DEEP_ARCHIVE"
    }

    noncurrent_version_expiration {
      noncurrent_days = var.retention_days
    }
    
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}