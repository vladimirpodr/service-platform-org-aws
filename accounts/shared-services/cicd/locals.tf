locals {
  # Base name prefix
  env_name = var.accounts.shared-services.short_name
  basename = "${var.project_name}-${local.env_name}-cicd"

  circleci_basename    = "${local.basename}-circleci-faas-user"
  codebuild_basename   = "${local.basename}-codebuild"
  artifacts_basename   = "${local.basename}-artifacts"
  github_oidc_basename = "${local.basename}-github-oidc"

  # Base resource-independent tags
  base_tags = {
    Application = var.project_name
    Environment = local.env_name
    Owner       = var.project_owner
  }

  # CIDR blocks
  vpc_cidr = var.cidr_blocks.cicd_vpc

  # Shared Transit Gateway config
  tgw = data.terraform_remote_state.network.outputs.tgw

  # Availability zones
  zone_names = slice(data.aws_availability_zones.aws_azs.names, 0, var.total_azs)
  zone_ids   = slice(data.aws_availability_zones.aws_azs.zone_ids, 0, var.total_azs)

  # CodeBuild local variables
  gh_repository = "https://github.com/org/aws-env-terraform.git"
  gh_pat_secret_arn  = data.terraform_remote_state.shrdsvc_security.outputs.github_pat_secret_arn
  gh_pat_secret_name = data.terraform_remote_state.shrdsvc_security.outputs.github_pat_secret_name

  # IAM OIDC Profider for GItHab Actions
  github_oidc_client_id           = "sts.amazonaws.com"
  github_oidc_provider_thumbprint = "6938fd4d98bab03faadb97b34396831e3780aea1"
  github_oidc_provider            = "token.actions.githubusercontent.com"
  github_oidc_provider_url        = "https://${local.github_oidc_provider}"
  org_org_repository          = "org/aws-org-terraform"
  org_env_repository          = "org/aws-env-terraform"

  # Bucket id for VPC Flow Logs
  log_archive_bucket = data.terraform_remote_state.logarch_logging.outputs.project_logs_bucket_id
}
