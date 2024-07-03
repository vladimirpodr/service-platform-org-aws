### Configure G Suite SSO SAML provider
### You schould create secret with saml metadata and use it to configure IAM SAML provider

data "aws_secretsmanager_secret" "sso_vpn" {
  arn = local.sso_vpn_metadata_secret
}

data "aws_secretsmanager_secret_version" "sso_vpn" {
  secret_id = data.aws_secretsmanager_secret.sso_vpn.id
}

resource "aws_iam_saml_provider" "sso_vpn" {
  name                   = "${local.basename}-vpn-sso-provider"
  saml_metadata_document = jsondecode(data.aws_secretsmanager_secret_version.sso_vpn.secret_string)["saml-metadata"]

  tags = {
    Name = "${local.basename}-sso-provider"
  }
}

data "aws_secretsmanager_secret" "sso_vpn_ssp" {
  arn = local.sso_vpn_ssp_metadata_secret
}

data "aws_secretsmanager_secret_version" "sso_vpn_ssp" {
  secret_id = data.aws_secretsmanager_secret.sso_vpn_ssp.id
}

resource "aws_iam_saml_provider" "sso_vpn_ssp" {
  name                   = "${local.basename}-vpn-sso-ssp-provider"
  saml_metadata_document = jsondecode(data.aws_secretsmanager_secret_version.sso_vpn_ssp.secret_string)["saml-metadata"]

  tags = {
    Name = "${local.basename}-vpn-sso-ssp-provider"
  }
}

module "client_vpn" {
  source = "git@github.com:org/aws-terraform-modules.git//client-vpn/vpn?ref=main"

  name = "${local.basename}-vpn"

  zone_names        = local.vpn_vpc_zone_names
  client_cidr_block = local.vpn_client_cidr
  subnets_assoc     = module.vpn_vpc.private_subnets.ids
  domain_name       = var.project_domain
  org_name          = var.project_organization
  vpc_id            = module.vpn_vpc.id
  target_cidr       = local.project_cidr

  ssp_saml_provider_arn = aws_iam_saml_provider.sso_vpn_ssp.arn
  saml_provider_arn     = aws_iam_saml_provider.sso_vpn.arn
}
