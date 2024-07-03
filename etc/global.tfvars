# Global variables
project_name   = "org-io"
aws_region    = "us-east-1"
project_owner  = "aws-management@org.com"
project_domain = "org.io"

accounts = {
  audit = {
    id         = "xxx"
    short_name = "audit"
  },
  log-archive = {
    id         = "xxx"
    short_name = "logarch"
  },
  management = {
    id         = "xxx"
    short_name = "mgmt"
  },
  production = {
    id         = "xxx"
    short_name = "prod"
  },
  development = {
    id         = "xxx"
    short_name = "dev"
  },
  networking = {
    id         = "xxx"
    short_name = "network"
  },
  shared-services = {
    id         = "xxx"
    short_name = "shrdsvc"
  },
  Peter_Kuczaj_Sandbox = {
    id         = "xxx"
    short_name = "p-k-sandbox"
  }
}

cidr_blocks = {
  project       = "10.80.0.0/12"
  egress_vpc    = "10.80.8.0/24"
  vpn_vpc       = "10.80.9.0/25"
  vpn_client    = "172.20.0.0/20"
  cicd_vpc      = "10.80.16.0/24"
}
