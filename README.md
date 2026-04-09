# truenas-terraform-s3-setup

Terraform module for provisioning an S3 bucket and least-privilege IAM user for TrueNAS SCALE cloud sync tasks. Objects transition to S3 Glacier Deep Archive after a configurable number of days for cost-effective disaster recovery storage.

Versioning is intentionally not enabled. TrueNAS uses `transfer_mode=SYNC` so S3 always mirrors local state. Local ZFS snapshots provide version history on the NAS itself — enabling S3 versioning with DEEP_ARCHIVE would add a 180-day minimum storage charge on every noncurrent object for no practical benefit.

---

## Resources

- S3 bucket (no versioning)
- Lifecycle rule — transitions to DEEP_ARCHIVE after `archive_days`, aborts incomplete multipart uploads after 7 days
- IAM user with least-privilege S3 policy (put, get, delete, list)
- IAM access key for TrueNAS cloud sync credentials

---

## Prerequisites

- Terraform >= 1.5.0
- Two AWS CLI profiles:
  - **`InfraProvisioner`** — used for S3 resources. Requires `s3:*` on the target bucket.
  - **`AdministratorAccess`** (or equivalent) — used for IAM resources. Requires `iam:CreateUser`, `iam:CreateAccessKey`, `iam:PutUserPolicy`. Set via `var.iam_admin_profile`.

```bash
aws sso login --profile InfraProvisioner
aws sso login --profile AdministratorAccess
```

---

## Usage

```bash
cp variables.tf.example variables.tf
# Edit variables.tf with your bucket name and profile names

terraform init
terraform plan
terraform apply
```

Retrieve the secret key after apply:

```bash
terraform output -raw secret_access_key
```

---

## Variables

| Name | Description | Default |
|---|---|---|
| `aws_region` | AWS region | `us-east-1` |
| `bucket_name` | Globally unique S3 bucket name | `my-nas-backups` |
| `iam_user_name` | IAM user name for TrueNAS | `truenas-s3-sync-user` |
| `archive_days` | Days before transitioning to DEEP_ARCHIVE | `1` |
| `iam_admin_profile` | AWS profile with IAM write permissions | `AdministratorAccess` |

---

## Outputs

| Name | Description |
|---|---|
| `access_key_id` | IAM access key ID |
| `secret_access_key` | IAM secret access key (sensitive) |
| `bucket_name` | S3 bucket name |
| `bucket_arn` | S3 bucket ARN |
| `bucket_domain_name` | S3 bucket domain name |

---

## TrueNAS Configuration

In TrueNAS SCALE, create a cloud sync task using the IAM credentials output by this module:

- **Provider:** Amazon S3
- **Access Key ID:** `terraform output access_key_id`
- **Secret Access Key:** `terraform output -raw secret_access_key`
- **Bucket:** value of `bucket_name`
- **Region:** value of `aws_region`
- **Transfer mode:** Sync
- **Storage class:** DEEP_ARCHIVE

---

## State management

Terraform state is stored locally. The `variables.tf` file is gitignored — use `variables.tf.example` as the template and never commit real values.
