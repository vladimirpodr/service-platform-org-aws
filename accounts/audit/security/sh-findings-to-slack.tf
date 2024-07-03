resource "aws_iam_role" "chatbot_send_to_slack" {
  name = "${local.sh_findings_to_slack_name}-chatbot-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "sns.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${local.sh_findings_to_slack_name}-chatbot-role"
  }
}

module "chatbot_send_to_slack" {
  source  = "git@github.com:org/aws-terraform-modules.git//chatbot-slack-configuration?ref=main"

  configuration_name = "${local.sh_findings_to_slack_name}-chatbot"
  iam_role_arn       = aws_iam_role.chatbot_send_to_slack.arn
  slack_channel_id   = local.chatbot_slack_channel_id
  slack_workspace_id = local.chatbot_slack_workspace_id

  sns_topic_arns = [
    aws_sns_topic.send_to_slack.arn
  ]
}

resource "aws_cloudwatch_log_group" "chatbot_send_to_slack" {
  name              = "/aws/chatbot/${local.sh_findings_to_slack_name}-chatbot"
  retention_in_days = 14

  tags = {
    Name = "${local.sh_findings_to_slack_name}-chatbot"
  }
}


# SNS Topic
resource "aws_iam_role" "sns_feedback_role" {
  name = "${local.sh_findings_to_slack_name}-sns-feedback-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "sns.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name   = "inline-policy"
    policy = data.aws_iam_policy_document.sns_feedback_role_inline_policy.json
  }

  tags = {
    Name = "${local.sh_findings_to_slack_name}-sns-feedback-role"
  }
}

data "aws_iam_policy_document" "sns_feedback_role_inline_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutMetricFilter",
      "logs:PutRetentionPolicy"
    ]
    resources = ["*"]
  }
}

resource "aws_sns_topic" "send_to_slack" {
  name              = "${local.sh_findings_to_slack_name}-sns-topic"
  kms_master_key_id = module.sns-kms-key.key_id

  http_success_feedback_sample_rate = 0
  http_success_feedback_role_arn    = aws_iam_role.sns_feedback_role.arn
  http_failure_feedback_role_arn    = aws_iam_role.sns_feedback_role.arn

  tags = {
    Name = "${local.sh_findings_to_slack_name}-sns-topic"
  }
}

resource "aws_sns_topic_policy" "send_to_slack" {
  arn    = aws_sns_topic.send_to_slack.arn
  policy = data.aws_iam_policy_document.send_to_slack.json
}

data "aws_iam_policy_document" "send_to_slack" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.send_to_slack.arn]
  }
}

# If your topic has SSE activated, then your Amazon SNS topic must use an AWS KMS key that is customer managed. This KMS key must include a custom key policy that gives other AWS services sufficient key usage permissions.
module "sns-kms-key" {
  source  = "git@github.com:org/aws-terraform-modules.git//kms/"

  description             = "${local.sh_findings_to_slack_name}-sns-topic encryption key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  # Policy
  enable_default_policy     = true
  key_service_users         = ["events.amazonaws.com"]

  # Aliases
  aliases = ["sns/${local.sh_findings_to_slack_name}-sns-topic-kms-key"]

  tags = {
    Name = "${local.sh_findings_to_slack_name}-sns-topic-kms-key"
  }
}


# CloudWatch Event Rule
resource "aws_cloudwatch_event_rule" "send_to_slack" {
  name        = "${local.sh_findings_to_slack_name}-event-rule"
  description = "Send Security Hub findings to Slack via AWS Chatbot"

  event_pattern = <<EOF
{
    "source": [
        "aws.securityhub"
     ],
    "detail-type": [
        "Security Hub Findings - Imported"
    ],
    "detail": {
        "findings": {
            "Severity": {
                "Label": [
                    "HIGH",
                    "CRITICAL",
                    "MEDIUM"
                ]
            },
            "Workflow": {
                "Status": [
                    "NEW"
                ]
            },
            "RecordState": [
                "ACTIVE"
            ],
            "Compliance": {
                "Status": [
                    "FAILED"
                ]
            }
        }
    }
}
EOF

  tags = {
    Name = "${local.sh_findings_to_slack_name}-event-rule"
  }
}

resource "aws_cloudwatch_event_target" "send_to_slack" {
  rule      = aws_cloudwatch_event_rule.send_to_slack.name
  target_id = "SendToSlack"
  arn       = aws_sns_topic.send_to_slack.arn
}
