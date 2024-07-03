terraform {
  backend "s3" {}
  required_providers {
    aws = {
      version = "~> 4.44.0"
    }
  }
}
