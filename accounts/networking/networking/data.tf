data "aws_availability_zones" "aws_azs" {}

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
