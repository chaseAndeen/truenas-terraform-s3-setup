resource "aws_s3_bucket" "nas_backups" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "nas_backups" {
  bucket = aws_s3_bucket.nas_backups.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Versioning is intentionally off. TrueNAS SYNC mode mirrors local state to S3;
# version history is handled by local ZFS snapshots. S3 versioning + DEEP_ARCHIVE
# would incur a 180-day minimum charge on every noncurrent object.

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

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}
