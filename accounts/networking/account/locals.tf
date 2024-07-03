locals {
  # Base name prefix
  env_name = var.accounts.networking.short_name
  basename = "${var.project_name}-${local.env_name}-account"

  # Base resource-independent tags
  base_tags = {
    Application = var.project_name
    Environment = local.env_name
    Owner       = var.project_owner
  }

  log_archive_account_name = var.accounts.log-archive.short_name
  log_archive_account_id   = var.accounts.log-archive.id

  organization_config_rule_lambda_role_arn = data.terraform_remote_state.mgmt_orgznization.outputs.config_rule_lambda_role_arn
}
