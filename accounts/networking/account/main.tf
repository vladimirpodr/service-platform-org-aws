provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = local.base_tags
  }

  assume_role {
    role_arn = "arn:aws:iam::552249246765:role/org-io-network-shrdsvc-assume-role"
  }
}
