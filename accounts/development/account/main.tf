provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = local.base_tags
  }

  assume_role {
    role_arn = "arn:aws:iam::217004862555:role/org-io-dev-shared-services-assume-role"
  }
}
