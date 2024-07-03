# Managed rules
resource "aws_config_organization_managed_rule" "main" {
  for_each = local.config_rules

  name              = each.key
  description       = each.value.description
  rule_identifier   = each.value.source_identifier
  input_parameters  = lookup(each.value, "input_parameters", null)
  excluded_accounts = [data.aws_organizations_organization.main.master_account_id]
}

# Custom rules

# AWS Config rule to continuously monitor unused IAM roles
resource "aws_lambda_permission" "config_rule_unused_iam_role" {
  action        = "lambda:InvokeFunction"
  function_name = module.config_rule_unused_iam_role_lambda.arn
  principal     = "config.amazonaws.com"
  statement_id  = "AllowExecutionFromConfig"
}

resource "aws_config_organization_custom_rule" "config_rule_unused_iam_role" {
  depends_on = [
    aws_lambda_permission.config_rule_unused_iam_role
  ]

  lambda_function_arn = module.config_rule_unused_iam_role_lambda.arn
  name                = local.config_rule_unused_iam_role_name
  trigger_types       = ["ScheduledNotification"]
  input_parameters    = "{\"role_whitelist\":\"${local.config_rule_unused_iam_role_whitelist}\",\"max_days_for_last_used\":\"${local.config_rule_unused_iam_role_max_days_for_last_used}\"}"
}