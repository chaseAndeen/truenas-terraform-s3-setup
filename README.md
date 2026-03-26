# truenas-terraform-s3-setup

Terraform module for provisioning an S3 bucket and least-privilege IAM user for TrueNAS SCALE cloud sync tasks. Objects transition to S3 Glacier Deep Archive after a configurable number of days, with noncurrent version expiration for cost control.

---

## Resources

- S3 bucket with versioning enabled
- Lifecycle rule — transitions to Deep Archive, expires noncurrent versions, aborts incomplete multipart uploads after 7 days
- IAM user with scoped S3 policy (put, get, delete, list)
- IAM access key for TrueNAS cloud sync credentials

---

## Prerequisites

- Terraform >= 1.5.0
- AWS CLI configured with the `InfraProvisioner` SSO profile
- `aws sso login --profile InfraProvisioner`

---

## Usage

```bash
cp variables.tf.example variables.tf
# Edit variables.tf with your values

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
| `bucket_name` | Globally unique S3 bucket name | `kernelstack-infra-backups` |
| `iam_user_name` | IAM user name for TrueNAS | `truenas-s3-sync-user` |
| `archive_days` | Days before transitioning to Deep Archive | `1` |
| `retention_days` | Days to retain noncurrent versions | `180` |

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
