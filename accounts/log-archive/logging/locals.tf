locals {
  # Base name prefix
  env_name = var.accounts.log-archive.short_name
  basename = "${var.project_name}-${local.env_name}-logging"

  # Base resource-independent tags
  base_tags = {
    Application = var.project_name
    Environment = local.env_name
    Owner       = var.project_owner
  }

  s3_access_bucket_name    = "${local.basename}-s3-access-bucket"
  lb_access_bucket_name    = "${local.basename}-lb-access-bucket"
  project_logs_bucket_name = "${local.basename}-project-logs-bucket"
}
