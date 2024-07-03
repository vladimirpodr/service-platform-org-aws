resource "aws_accessanalyzer_analyzer" "accessanalyzer" {
  analyzer_name = local.aa_name
  type          = "ORGANIZATION"
}

resource "aws_accessanalyzer_archive_rule" "accessanalyzer_sso_reserved" {
  analyzer_name = aws_accessanalyzer_analyzer.accessanalyzer.id
  rule_name     = "${local.aa_name}-sso-reserved-rule"

  filter {
    criteria = "resourceType"
    eq       = ["AWS::IAM::Role"]
  }

    filter {
    criteria = "resource"
    contains = ["AWSReservedSSO"]
  }
}
