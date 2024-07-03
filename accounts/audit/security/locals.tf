locals {
  # Base name prefix
  env_name = var.accounts.audit.short_name
  basename = "${var.project_name}-${local.env_name}-security"

  aa_name                   = "${local.basename}-access-analyzer"
  sh_findings_to_slack_name = "${local.basename}-sh-findings-to-slack"

  # Base resource-independent tags
  base_tags = {
    Application = var.project_name
    Environment = local.env_name
    Owner       = var.project_owner
  }

  chatbot_slack_channel_id   = "C04BDS3CV0V"
  chatbot_slack_workspace_id = "T0JQ7U4C8"
}
