provider "aws" {

  default_tags {
    tags = local.base_tags
  }

  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::665073570289:role/org-io-shrdsvc-assume-role"
  }
}
