# Create KMS key to use with AWS Control Tower.

module "control_tower_kms_key" {
  source  = "git@github.com:org/aws-terraform-modules.git//kms/"

  description             = " KMS key to use with AWS Control Tower and encrypt and decrypt AWS CloudTrail and AWS Config resources."
  deletion_window_in_days = 7

  # Policy
  key_service_users = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com"
  ]

  # Aliases
  aliases = ["${var.project_name}/control-tower-kms-key"]

  tags = {
    Name = "${var.project_name}-control-tower-kms-key"
  }
}

output "control_tower_kms_key" {
    value = module.control_tower_kms_key
}
