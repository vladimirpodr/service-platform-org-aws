data "terraform_remote_state" "mgmt_orgznization" {
  backend = "s3"
  config = {
    role_arn = "arn:aws:iam::631441100214:role/org-io-mgmt-shrdsvc-assume-role"
    bucket   = "${var.project_name}-mgmt-tfstate-bucket"
    key      = "mgmt/organization/terraform.tfstate"
    region   = var.aws_region
  }
}
