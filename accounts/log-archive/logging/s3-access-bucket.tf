module "s3_access_bucket" {
  source = "git@github.com:org/aws-terraform-modules.git//s3?ref=main"

  name          = local.s3_access_bucket_name
  sse_algorithm = "AES256"

  attach_policy                          = true
  policy                                 = data.aws_iam_policy_document.organization_access_s3_access_bucket.json
  attach_deny_insecure_transport_policy  = true
  attach_s3_access_log_delivery_policy   = true

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
