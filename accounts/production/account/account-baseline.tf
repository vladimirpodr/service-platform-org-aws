module "account-baseline" {
  source = "git@github.com:org/aws-terraform-modules.git//account-baseline?ref=main"

  name         = local.basename
  project_name = var.project_name

  enable_ebs_encryption_by_default      = true
  enable_s3_account_public_access_block = true
  enable_iam_account_password_policy    = true

  enable_s3_access_logs_s3_bucket         = true
  enable_lb_access_logs_s3_bucket         = true
  s3_bucket_replication_dest_account_id   = local.log_archive_account_id
  s3_bucket_replication_dest_account_name = local.log_archive_account_name

  enable_organization_config_rule_lambda_assume_role = true
  organization_config_rule_lambda_role_arn           = local.organization_config_rule_lambda_role_arn

  # Security Hub config
  enable_sh_aws_foundational_security_best_practices_standard = true
}
