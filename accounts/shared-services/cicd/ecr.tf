### ECR
module "ecr" {
  source = "git@github.com:org/aws-terraform-modules.git//ecr"

  basename                 = local.artifacts_basename
  names                    = local.ecr_repositories
  enable_lifecycle_policy  = true
  amount_keep_images       = 50
  allow_push_users_arn     = [ aws_iam_user.circleci.arn ]
}

### Outputs
output "ecr" {
  value = {
    repo_names = module.ecr.repo_names
    repo_arns  = module.ecr.repo_arns
  }
}

### Local variable includes the list of applications to create repositories for
locals {
  ecr_repositories = [
  "admin-api",
  "admin-service",
  "admin-ui",
  "ai-service",
  "aws-timestream-api",
  "aws-timestream-measures-backfill-service",
  "aws-timestream-measures-service",
  "data-import-bouncer",
  "data-staging-transformer",
  "datadog-webhook-api",
  "db-deploy-service",
  "event-api",
  "explore-ui",
  "flowing-lift-system-api",
  "flowing-lift-system-service",
  "gas-lift-simulator-service",
  "gas-lift-system-api",
  "gas-lift-system-service",
  "grafana-service",
  "graph-api",
  "graph-deploy-service",
  "hrac-control-system-api",
  "hrac-control-system-service",
  "hrac-hardware-api",
  "hrac-hardware-service",
  "hrac-ip-multiplexer-service",
  "hrac-ip-network-service",
  "hrac-iridium-network-service",
  "lookup-api",
  "legacy-platform-hoover-service",
  "monitor-api",
  "monitor-service",
  "mqtt-kafka-bridge-service",
  "mqtt-watchtower",
  "notification-service",
  "opc-org-sim-service",
  "opc-cnx-service",
  "opc-elk-service",
  "opc-encino-service",
  "opc-maverick-service",
  "opc-range-service",
  "opc-simulator",
  "opc-swn-service",
  "opc-timestream-range-service",
  "opc-tourmaline-service",
  "opc-up-service",
  "opc-alta-service",
  "opc-whiting-service",
  "opc-bedrock-service",
  "organization-api",
  "organization-service",
  "plunger-control-system-api",
  "plunger-control-system-service",
  "plunger-lift-system-api",
  "plunger-lift-system-service",
  "portal-ui",
  "public-api",
  "public-event-broadcast-service",
  "report-service",
  "rod-lift-system-api",
  "rod-lift-system-service",
  "scenario-builder",
  "snowflake-api",
  "snowflake-deploy-service",
  "sql-rabbit-bridge-service",
  "sqlserver-kafka-bridge-tourmaline-service",
  "swo-poc-control-system-api",
  "swo-poc-control-system-service",
  "tenant-xerox-api",
  "tensorflow-service",
  "time-api",
  "user-api",
  "user-service",
  "well-api",
  "well-service",
  "zedi-data-loader"
  ]
}
