provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = local.base_tags
  }

  assume_role {
    role_arn = "arn:aws:iam::428361613096:role/org-io-audit-shrdsvc-assume-role"
  }
}
