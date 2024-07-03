provider "aws" {

  default_tags {
    tags = local.base_tags
  }

  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::665073570289:role/org-io-shrdsvc-assume-role"
  }
}

### Declare Transit AWS Provider with assumed role to have access to account with shared Transit Gateway
provider "aws" {
  region = "us-east-1"
  alias = "transit"

  default_tags {
    tags = local.base_tags
  }

  assume_role {
    role_arn = "arn:aws:iam::552249246765:role/org-io-network-shrdsvc-assume-role"
  }
}
