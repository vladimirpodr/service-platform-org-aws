# Environment specific variables


# Don't enable Tag Policy for accounts in Sandbox OU.
account_assignment = {
  Production = {
    id                = "xxx"
    enable_tag_policy = true
    assignments = {
      # Group Name -> Permission Set
      AWSAdmins              = "AdministratorAccess"
      AWSProductionReadOnly  = "ReadOnlyAccess"
      AWSProductionPowerUser = "PowerUserAccess"
      AWSSecOpsReadOnly      = "SecurityAudit"
    }
  },
  Development = {
    id                = "xxx"
    enable_tag_policy = true
    assignments = {
      # Group Name -> Permission Set
      AWSAdmins               = "AdministratorAccess"
      AWSDevelopmentReadOnly  = "ReadOnlyAccess"
      AWSDevelopmentPowerUser = "PowerUserAccess"
      AWSSecOpsReadOnly       = "SecurityAudit"
    }
  },
  Networking = {
    id                = "xxx"
    enable_tag_policy = true
    assignments = {
      # Group Name -> Permission Set
      AWSAdmins         = "AdministratorAccess"
      AWSSecOpsReadOnly = "SecurityAudit"
    }
  },
  Shared-Services = {
    id                = "xxx"
    enable_tag_policy = true
    assignments = {
      # Group Name -> Permission Set
      AWSAdmins         = "AdministratorAccess"
      AWSSecOpsReadOnly = "SecurityAudit"
    }
  },
  Audit = {
    id                = "xxx"
    enable_tag_policy = true
    assignments = {
      # Group Name -> Permission Set
      AWSAdmins          = "AdministratorAccess"
      AWSSecOpsPowerUser = "PowerUserAccess"
      AWSSecOpsReadOnly  = "SecurityAudit"
    }
  },
  Log-Archive = {
    id                = "xxx"
    enable_tag_policy = true
    assignments = {
      # Group Name -> Permission Set
      AWSAdmins          = "AdministratorAccess"
      AWSSecOpsPowerUser = "PowerUserAccess"
      AWSSecOpsReadOnly  = "SecurityAudit"
    }
  },
  Management = {
    id                = "xxx"
    enable_tag_policy = true
    assignments = {
      # Group Name -> Permission Set
      AWSAdmins         = "AdministratorAccess"
      AWSSecOpsReadOnly = "SecurityAudit"
      AWSFinOps         = "Billing"
    }
  },
  Peter_Kuczaj_Sandbox = {
    id                = "xxx"
    enable_tag_policy = false
    assignments = {
      # Group Name -> Permission Set
      AWSAdmins               = "AdministratorAccess"
      AWSSandboxPowerUser     = "ReadOnlyAccess"
      AWSSecOpsReadOnly       = "SecurityAudit"
    }
  }
}
