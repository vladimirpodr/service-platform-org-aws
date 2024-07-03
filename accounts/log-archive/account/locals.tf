locals {
  # Base name prefix
  env_name = var.accounts.log-archive.short_name
  basename = "${var.project_name}-${local.env_name}-account"

  # Base resource-independent tags
  base_tags = {
    Application = var.project_name
    Environment = local.env_name
    Owner       = var.project_owner
  }

  organization_config_rule_lambda_role_arn = data.terraform_remote_state.mgmt_orgznization.outputs.config_rule_lambda_role_arn
}
