resource "aws_s3_bucket" "nas_backups" {
  bucket = var.bucket_name
}

# No versioning resource — versioning is never enabled on this bucket.
# TrueNAS uses transfer_mode=SYNC so S3 always mirrors local state.
# TrueNAS local ZFS snapshots (every 6h, 2-week retention) provide version
# history locally. S3 versioning + DEEP_ARCHIVE would add a 180-day minimum
# storage charge on every noncurrent object, which is expensive for backup
# datasets that churn regularly.

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
