### Archive lambda code before upload
data "archive_file" "config_rule_unused_iam_role_lambda" {
  type        = "zip"
  source_dir  = "./files/config-rule-unused-iam-role"
  output_path = "./files/config-rule-unused-iam-role.zip"
}

# Attach policy to the Lambda role
data "aws_iam_policy_document" "config_rule_unused_iam_role_lambda" {
  statement {
    actions = [ "config:PutEvaluations" ]

    resources = [ "*" ]
  }

  statement {
    actions = [ "iam:GetAccountAuthorizationDetails" ]

    resources = [ "*" ]
  }

  statement {
    actions = [ "sts:AssumeRole" ]

    resources = [ "arn:aws:iam::*:role/${local.organization_config_rule_lambda_assume_role_name}" ]
  }
}

module "config_rule_unused_iam_role_lambda" {
  source = "git@github.com:org/aws-terraform-modules.git//lambda?ref=main"

  name        = local.config_rule_unused_iam_role_name
  description = "Lambda continuously monitors unused IAM roles with AWS Config"

  lambda_function_handler = "lambda_function.evaluate_compliance"
  source_code_path        = data.archive_file.config_rule_unused_iam_role_lambda.output_path

  attach_policy = true
  policy        = data.aws_iam_policy_document.config_rule_unused_iam_role_lambda.json

  environment_variables = {
    ASSUME_ROLE_NAME = local.organization_config_rule_lambda_assume_role_name
  }
}
