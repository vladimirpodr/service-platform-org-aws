provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = local.base_tags
  }

  assume_role {
    role_arn = "arn:aws:iam::631441100214:role/org-io-mgmt-shrdsvc-assume-role"
  }
}
