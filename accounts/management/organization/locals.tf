locals {
  # Base name prefix
  env_name = var.accounts.management.short_name
  basename = "${var.project_name}-${local.env_name}-organization"

  organization_config_rule_lambda_assume_role_name = "${var.project_name}-organization-config-rule-lambda-assume-role"

  # Base resource-independent tags
  base_tags = {
    Application = var.project_name
    Environment = local.env_name
    Owner       = var.project_owner
  }

  # Organization policies
  mandatory_tags = concat(["Name"], keys(local.base_tags))

  accounts_with_enabled_tag_policy = { for k, v in var.account_assignment: k => v if v.enable_tag_policy == true }

  # SSO local variables
  sso_permission_sets = {
    AdministratorAccess = {
      description = "Administrator access for all services and resources."
      policy_arn  = "arn:aws:iam::aws:policy/AdministratorAccess"
    },
    Billing = {
      description = "Provides access to billing information and configuration."
      policy_arn  = "arn:aws:iam::aws:policy/job-function/Billing"
    },
    SecurityAudit = {
      description = "Read-only access to all security services and resources."
      policy_arn  = "arn:aws:iam::aws:policy/SecurityAudit"
    },
    ReadOnlyAccess = {
      description = "Read-only access to all services and resources."
      policy_arn  = "arn:aws:iam::aws:policy/ReadOnlyAccess"
    },
    PowerUserAccess = {
      description = "Full access to AWS services and resources, but does not allow management of Users and groups."
      policy_arn  = "arn:aws:iam::aws:policy/PowerUserAccess"
    }
  }

  # Config rules
  oldest_eks_version = 1.23

  config_rule_unused_iam_role_name                   = "${local.basename}-config-rule-unused-iam-role"
  config_rule_unused_iam_role_whitelist              = "/aws-controltower-*|/AWSControlTowerExecution|/aws-service-role/*|/aws-reserved/sso.amazonaws.com/*|/OrganizationAccountAccessRole" # a pipe (“|”) separated whitelist of role pathnames using simple pathname matching
  config_rule_unused_iam_role_max_days_for_last_used = 60

  config_rules = {
    "backup-recovery-point-encrypted" = {
      description       = "Checks if a recovery point is encrypted. The rule is NON_COMPLIANT if the recovery point is not encrypted.",
      source_identifier = "BACKUP_RECOVERY_POINT_ENCRYPTED"
    },
    "ec2-ebs-encryption-by-default" = {
      description       = "Check that Amazon Elastic Block Store (EBS) encryption is enabled by default.",
      source_identifier = "EC2_EBS_ENCRYPTION_BY_DEFAULT"
    },
    "efs-encrypted-check" = {
      description       = "Checks if Amazon Elastic File System (Amazon EFS) is configured to encrypt the file data using AWS Key Management Service (AWS KMS)",
      source_identifier = "EFS_ENCRYPTED_CHECK"
    },
    "eks-cluster-oldest-supported-version" = {
      description       = "Checks if an Amazon Elastic Kubernetes Service (EKS) cluster is running the oldest supported version.",
      source_identifier = "EKS_CLUSTER_OLDEST_SUPPORTED_VERSION"
      input_parameters  = "{ \"oldestVersionSupported\" : \"${local.oldest_eks_version}\" }"
    },
    "eks-secrets-encrypted" = {
      description       = "Checks if Amazon Elastic Kubernetes Service clusters are configured to have Kubernetes secrets encrypted using AWS Key Management Service (KMS) keys.",
      source_identifier = "EKS_SECRETS_ENCRYPTED"
    },
    "encrypted-volumes" = {
      description       = "Checks if the EBS volumes that are in an attached state are encrypted.",
      source_identifier = "ENCRYPTED_VOLUMES"
    },
    "rds-storage-encrypted" = {
      description       = "Checks whether storage encryption is enabled for your RDS DB instances.",
      source_identifier = "RDS_STORAGE_ENCRYPTED"
    },
    "rds-snapshot-encrypted" = {
      description       = "Checks whether Amazon Relational Database Service (Amazon RDS) DB snapshots are encrypted.",
      source_identifier = "RDS_SNAPSHOT_ENCRYPTED"
    },
    "s3-bucket-server-side-encryption-enabled" = {
      description       = "Checks if your Amazon S3 bucket either has the Amazon S3 default encryption enabled or that the Amazon S3 bucket policy explicitly denies put-object requests without server side encryption that uses AES-256 or AWS Key Management Service.",
      source_identifier = "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"
    }
  }
}
