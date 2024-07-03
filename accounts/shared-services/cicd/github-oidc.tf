# IAM OIDC Profider for GItHab Actions

resource "aws_iam_openid_connect_provider" "github" {
  client_id_list  = [local.github_oidc_client_id]
  thumbprint_list = [local.github_oidc_provider_thumbprint]
  url             = local.github_oidc_provider_url

  tags = {
    Name = "${local.github_oidc_basename}-provider"
  }
}

# Roles and policies for federated OIDC identities
data "aws_iam_policy_document" "org_org_repository" {
  statement {
    sid = "OrgRepoConnect"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringLike"
      variable = "${local.github_oidc_provider}:sub"
      values   = ["repo:${local.org_org_repository}:*"]
    }
  }
}

data "aws_iam_policy_document" "org_env_repository" {
  statement {
    sid = "EnvRepoConnect"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringLike"
      variable = "${local.github_oidc_provider}:sub"
      values   = ["repo:${local.org_env_repository}:*"]
    }
  }
}

resource "aws_iam_role" "org_org_repository" {
  name                 = "${local.github_oidc_basename}-org-repo-role"
  assume_role_policy   = data.aws_iam_policy_document.org_org_repository.json
  max_session_duration = 7200

  tags = {
    Name = "${local.github_oidc_basename}-org-repo-role"
  }
}

resource "aws_iam_role" "org_env_repository" {
  name                 = "${local.github_oidc_basename}-env-repo-role"
  assume_role_policy   = data.aws_iam_policy_document.org_env_repository.json
  max_session_duration = 7200

  tags = {
    Name = "${local.github_oidc_basename}-env-repo-role"
  }
}

resource "aws_iam_role_policy_attachment" "org_org_repository" {
  role = aws_iam_role.org_org_repository.name

  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "org_env_repository" {
  role = aws_iam_role.org_env_repository.name

  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
