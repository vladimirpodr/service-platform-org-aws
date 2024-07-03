### Outputs
output "permission_sets_arn" {
  value = module.permission_set
}

output "config_rule_lambda_role_arn" {
  value = module.config_rule_unused_iam_role_lambda.role_arn
}
