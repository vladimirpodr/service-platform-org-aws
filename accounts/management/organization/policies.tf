locals {

}

# Due to the tag policy content size limit - create separate policy for each tag key.
module "tag_policy" {
  source   = "git@github.com:org/aws-terraform-modules.git//organization/policy?ref=main"
  for_each = toset(local.mandatory_tags)

  basename = "${local.basename}-tag-${lower(each.key)}"

  attachment_target = local.accounts_with_enabled_tag_policy
  policy_type       = "TAG_POLICY"
  policy            = jsonencode(jsondecode(templatefile("${path.module}/files/tag-policy.tftpl", { tag = each.key })))

}

# module "tag_scp_policy" {
#   source   = "git@github.com:org/aws-terraform-modules.git//organization/policy?ref=main"
#   for_each = toset(local.mandatory_tags)

#   basename = "${local.basename}-tag-scp-${lower(each.key)}"

#   attachment_target = local.accounts_with_enabled_tag_policy
#   policy_type       = "SERVICE_CONTROL_POLICY"
#   policy            = jsonencode(jsondecode(templatefile("${path.module}/files/tag-scp-policy.tftpl", { tag = each.key })))
# }
