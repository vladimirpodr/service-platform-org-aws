# Common secrets
resource "aws_secretsmanager_secret" "github_pat_secret" {
  name        = "${local.basename}-github-pat-secret"
  description = "GitHub Personal Access Token."
  kms_key_id  = module.sm-kms.key_id
  policy      = data.aws_iam_policy_document.secretsmanager_secret.json

  tags = {
    Name = "${local.basename}-github-pat-secret"
  }
}

resource "aws_secretsmanager_secret" "network_vpn_ssp_sso_metadata_secret" {
  name        = "${local.basename}-network-vpn-portal-sso-metadata-secret"
  description = "This secret will be used as SAML metadata to configure IAM SAML provider and connect with G Suite."
  kms_key_id  = module.sm-kms.key_id
  policy      = data.aws_iam_policy_document.secretsmanager_secret.json

  tags = {
    Name = "${local.basename}-network-vpn-portal-sso-metadata-secret"
  }
}

resource "aws_secretsmanager_secret" "network_vpn_sso_metadata_secret" {
  name        = "${local.basename}-network-vpn-sso-metadata-secret"
  description = "This secret will be used as SAML metadata to configure IAM SAML provider and connect with G Suite"
  kms_key_id  = module.sm-kms.key_id
  policy      = data.aws_iam_policy_document.secretsmanager_secret.json

  tags = {
    Name = "${local.basename}-network-vpn-sso-metadata-secret"
  }
}

# Environment specific secrets
resource "aws_secretsmanager_secret" "argocd_google_oauth_client_secret" {
  for_each = toset(local.secrets_environments)

  name        = "${local.basename}-${each.key}-argocd-google-oauth-secret"
  description = "ArgoCD SSO: Google OAuth client secret."
  kms_key_id  = module.sm-kms.key_id
  policy      = data.aws_iam_policy_document.secretsmanager_secret.json

  tags = {
    Name = "${local.basename}-${each.key}-argocd-google-oauth-secret"
  }
}

resource "aws_secretsmanager_secret" "argocd_google_groups_json_secret" {
  for_each = toset(local.secrets_environments)

  name        = "${local.basename}-${each.key}-argocd-google-groups-json-secret"
  description = "	ArgoCD SSO: Google service account credentials in JSON format."
  kms_key_id  = module.sm-kms.key_id
  policy      = data.aws_iam_policy_document.secretsmanager_secret.json

  tags = {
    Name = "${local.basename}-${each.key}-argocd-google-groups-json-secret"
  }
}

resource "aws_secretsmanager_secret" "datadog_api_key_secret" {
  for_each = toset(local.secrets_environments)

  name        = "${local.basename}-${each.key}-datadog-api-secret"
  description = "DataDog API Key to use in Dev environment."
  kms_key_id  = module.sm-kms.key_id
  policy      = data.aws_iam_policy_document.secretsmanager_secret.json

  tags = {
    Name = "${local.basename}-${each.key}-datadog-api-secret"
  }
}
