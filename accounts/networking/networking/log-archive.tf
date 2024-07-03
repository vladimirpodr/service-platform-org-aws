module "log-archive" {
  source = "git@github.com:org/aws-terraform-modules.git//log-archive/"

  name = "${local.basename}-vpn-log-archive"

  log_source         = "ClientVPN"
  log_group          = module.client_vpn.log_group_name
  log_archive_bucket = local.log_archive_bucket
}
