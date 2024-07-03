# Common secrets
output "github_pat_secret_name" {
  value = aws_secretsmanager_secret.github_pat_secret.name
}

output "github_pat_secret_arn" {
  value = aws_secretsmanager_secret.github_pat_secret.arn
}

output "network_vpn_ssp_sso_metadata_secret_arn" {
  value = aws_secretsmanager_secret.network_vpn_ssp_sso_metadata_secret.arn
}

output "network_vpn_sso_metadata_secret_arn" {
  value = aws_secretsmanager_secret.network_vpn_sso_metadata_secret.arn
}

# Environment specific secrets
output "argocd_google_oauth_client_secret_arns" {
  value = {for k, v in aws_secretsmanager_secret.argocd_google_oauth_client_secret: k => v.arn}
}

output "argocd_google_groups_json_secret_arns" {
  value = {for k, v in aws_secretsmanager_secret.argocd_google_groups_json_secret: k => v.arn}
}

output "datadog_api_key_secret_arns" {
  value = {for k, v in aws_secretsmanager_secret.datadog_api_key_secret: k => v.arn}
}

# KMS keys
output "data_kms_arns" {
  value = {for k, v in module.data-kms: k => v.key_arn}
}
