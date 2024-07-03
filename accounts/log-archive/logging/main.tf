provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = local.base_tags
  }

  assume_role {
    role_arn = "arn:aws:iam::823345141005:role/org-io-logarch-shrdsvc-assume-role"
  }
}
