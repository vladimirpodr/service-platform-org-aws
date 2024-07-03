provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = local.base_tags
  }

  assume_role {
    role_arn = "arn:aws:iam::243395836600:role/org-io-prod-shared-services-assume-role"
  }
}
