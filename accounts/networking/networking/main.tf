provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = local.base_tags
  }

  assume_role {
    role_arn = "arn:aws:iam::552249246765:role/org-io-network-shrdsvc-assume-role"
  }
}

### Declare Transit AWS Provider with assumed role to have access to account with shared Transit Gateway
provider "aws" {
  alias  = "transit"
  region = "us-east-1"

  default_tags {
    tags = local.base_tags
  }

  assume_role {
    role_arn = "arn:aws:iam::552249246765:role/org-io-network-shrdsvc-assume-role"
  }
}
