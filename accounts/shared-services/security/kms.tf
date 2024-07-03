module "data-kms" {
  source  = "git@github.com:org/aws-terraform-modules.git//kms/"

  for_each = local.workloads_organization_sub_units

  description             = coalesce("${each.key} accounts data encryption key")
  deletion_window_in_days = 7

  # Policy
  enable_default_policy = true
  key_users             = ["*"]
  key_users_conditions  = [
    {
      test     = "ForAnyValue:StringLike"
      variable = "aws:PrincipalOrgPaths"
      values   = [each.value]
    }
  ]

  # Aliases
  aliases = ["${var.project_name}/${local.basename}-${each.key}-data-kms-key"]

  tags = {
    Name = "${local.basename}-${each.key}-data-kms-key"
  }
}

module "sm-kms" {
  source  = "git@github.com:org/aws-terraform-modules.git//kms/"

  description             = "Allow access through AWS Secrets Manager for all principals in the account that are authorized to use AWS Secrets Manager"
  deletion_window_in_days = 7

  # Policy
  enable_default_policy = true
  key_users_to_decrypt  = local.share_key_and_secrets_to_users
  key_users             = ["*"]
  key_users_conditions  = [
    {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [ data.aws_caller_identity.current.account_id ]
    },
    {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = [ "secretsmanager.us-east-1.amazonaws.com" ]
    }
  ]


  # Aliases
  aliases = ["${var.project_name}/${local.basename}-sm-kms-key"]

  tags = {
    Name = "${local.basename}-sm-kms-key"
  }
}
