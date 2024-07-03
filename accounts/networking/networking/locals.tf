

locals {
  # Base name prefix
  env_name = var.accounts.networking.short_name
  basename = "${var.project_name}-${local.env_name}-network"

  # Base resource-independent tags
  base_tags = {
    Application = var.project_name
    Environment = local.env_name
    Owner       = var.project_owner
  }

  # Availability zones
  vpc_zone_names     = slice(data.aws_availability_zones.aws_azs.names, 0, var.total_azs)
  vpn_vpc_zone_names = slice(data.aws_availability_zones.aws_azs.names, 0, 2)

  # CIDR blocks
  project_cidr    = var.cidr_blocks.project
  egress_vpc_cidr = var.cidr_blocks.egress_vpc
  vpn_vpc_cidr    = var.cidr_blocks.vpn_vpc
  vpn_client_cidr = var.cidr_blocks.vpn_client

  # Get secrets values from Shared-Services account
  sso_vpn_metadata_secret     = data.terraform_remote_state.shrdsvc_security.outputs.network_vpn_sso_metadata_secret_arn
  sso_vpn_ssp_metadata_secret = data.terraform_remote_state.shrdsvc_security.outputs.network_vpn_ssp_sso_metadata_secret_arn

  # Bucket id for VPC Flow Logs
  log_archive_bucket = data.terraform_remote_state.logarch_logging.outputs.project_logs_bucket_id
}
