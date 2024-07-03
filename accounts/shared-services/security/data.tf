data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "secretsmanager_secret" {
  statement {
    sid = "AllowPull"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy"
    ]

    principals {
      type        = "AWS"
      identifiers = local.share_key_and_secrets_to_users
    }

    resources = ["*"]
  }
}
