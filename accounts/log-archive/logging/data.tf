data "aws_organizations_organization" "current" {}

data "aws_iam_policy_document" "organization_access_lb_access_bucket" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:ReplicateDelete",
      "s3:ReplicateObject",
      "s3:List*",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning"
    ]

    resources = [
      "arn:aws:s3:::${local.lb_access_bucket_name}",
      "arn:aws:s3:::${local.lb_access_bucket_name}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [ data.aws_organizations_organization.current.id ]
    }
  }
}

data "aws_iam_policy_document" "organization_access_project_logs_bucket" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${local.project_logs_bucket_name}",
      "arn:aws:s3:::${local.project_logs_bucket_name}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [ data.aws_organizations_organization.current.id ]
    }
  }
}

data "aws_iam_policy_document" "organization_access_s3_access_bucket" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:ReplicateDelete",
      "s3:ReplicateObject",
      "s3:List*",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning"
    ]

    resources = [
      "arn:aws:s3:::${local.s3_access_bucket_name}",
      "arn:aws:s3:::${local.s3_access_bucket_name}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [ data.aws_organizations_organization.current.id ]
    }
  }
}
