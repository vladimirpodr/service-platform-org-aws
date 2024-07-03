### Data sources
# Networking Transit Gateway State
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    region   = var.aws_region
    bucket   = "org-io-network-tfstate-bucket"
    key      = "network/networking/terraform.tfstate"
    role_arn = "arn:aws:iam::552249246765:role/org-io-network-shrdsvc-assume-role"
  }
}

# Shared-Services Security State
data "terraform_remote_state" "shrdsvc_security" {
  backend = "s3"
  config = {
    region   = var.aws_region
    bucket   = "org-io-shrdsvc-tfstate-bucket"
    key      = "shared-services/security/terraform.tfstate"
    role_arn = "arn:aws:iam::665073570289:role/org-io-shrdsvc-assume-role"
  }
}

# Log-Archive Logging State
data "terraform_remote_state" "logarch_logging" {
  backend = "s3"
  config = {
    region   = var.aws_region
    bucket   = "org-io-logarch-tfstate-bucket"
    key      = "logarch/logging/terraform.tfstate"
    role_arn = "arn:aws:iam::823345141005:role/org-io-logarch-shrdsvc-assume-role"
  }
}

data "aws_availability_zones" "aws_azs" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_secretsmanager_secret" "gh_pat_secret" {
  arn = local.gh_pat_secret_arn
}

data "aws_secretsmanager_secret_version" "gh_pat_secret" {
  secret_id = data.aws_secretsmanager_secret.gh_pat_secret.id
}
