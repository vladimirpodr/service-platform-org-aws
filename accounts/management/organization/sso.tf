### Create permission sets with AWS managed policies
module "permission_set" {
  source   = "git@github.com:org/aws-terraform-modules.git//sso/permission-set?ref=main"
  for_each = local.sso_permission_sets

  name        = each.key
  description = each.value.description
  policy_arn  = each.value.policy_arn
}

### Assign user groups and permission sets to specific accounts
module "account-assignment" {
  source   = "git@github.com:org/aws-terraform-modules.git//sso/account-assignment?ref=main"
  for_each = var.account_assignment

  account_id          = each.value.id
  assignments         = each.value.assignments
  permission_sets_arn = module.permission_set
}
