module "project_logs_bucket" {
  source = "git@github.com:org/aws-terraform-modules.git//s3?ref=main"

  name          = local.project_logs_bucket_name
  sse_algorithm = "AES256"

  attach_policy = true
  policy        = data.aws_iam_policy_document.organization_access_project_logs_bucket.json

  attach_deny_insecure_transport_policy  = true
  attach_log_delivery_policy             = true
  # attach_deny_unencrypted_objects_policy = true

  logging = {
    target_bucket = local.s3_access_bucket_name
    target_prefix = "${local.project_logs_bucket_name}/"
  }

  versioning = {
    status     = true
    mfa_delete = false
  }

  lifecycle_rules = [
    {
      id = "TransitionRule"

      transition = [
        {
          days          = 90
          storage_class = "STANDARD_IA"
        },
        {
          days          = 180
          storage_class = "GLACIER"
        }
      ]

      noncurrent_version_transition = [
        {
          days          = 90
          storage_class = "STANDARD_IA"
        },
        {
          days          = 180
          storage_class = "GLACIER"
        }
      ]
    }
  ]
}
