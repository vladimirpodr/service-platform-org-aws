locals {
  # Base name prefix
  env_name = var.accounts.shared-services.short_name
  basename = "${var.project_name}-${local.env_name}-security"

  # Base resource-independent tags
  base_tags = {
    Application = var.project_name
    Environment = local.env_name
    Owner       = var.project_owner
  }

  # Allow terraform with assumed roles to get SM secrets values that are encrypted with KMS
  share_key_and_secrets_to_users = [
      "arn:aws:iam::665073570289:role/org-io-shrdsvc-cicd-codebuild-role",
      "arn:aws:iam::217004862555:role/org-io-dev-shared-services-assume-role",
      "arn:aws:iam::552249246765:role/org-io-network-shrdsvc-assume-role"

  ]

  workloads_organization_sub_units = {
    dev = "o-jh8mut6uhc/r-7s1w/ou-7s1w-0jzq5hl0/ou-7s1w-hiezzdgl/"
  }

  secrets_environments = [
    "dev",
    "prod"
  ]
}
