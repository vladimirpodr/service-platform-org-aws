### Configure GitHub source credentials


resource "aws_codebuild_source_credential" "codebuild" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = jsondecode(data.aws_secretsmanager_secret_version.gh_pat_secret.secret_string)["token"]
}

### Configure CodeBuild service role

data "aws_iam_policy_document" "codebuild" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
      identifiers = [
        "codebuild.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "${local.codebuild_basename}-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild.json
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = aws_iam_role.codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


resource "aws_security_group" "codebuild" {
  name        = "${local.codebuild_basename}-sg"
  description = "Allow codebuild access to private resources."
  vpc_id      = module.vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.codebuild_basename}-sg"
  }
}

resource "aws_codebuild_project" "codebuild_tf_plan" {
  name          = "${local.codebuild_basename}-tf-plan"
  build_timeout = "10"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  vpc_config {
    vpc_id = module.vpc.id

    subnets = module.vpc.private_subnets.ids

    security_group_ids = [
      aws_security_group.codebuild.id
    ]
  }

  source {
    buildspec           =  templatefile("files/buildspec-tf-plan.tftpl", {
      gh_pat_secret_name = local.gh_pat_secret_name
    })
    git_clone_depth     = 1
    insecure_ssl        = false
    report_build_status = false
    type                = "GITHUB"
    location            = local.gh_repository
    git_submodules_config {
      fetch_submodules = false
    }
  }

  tags = {
    Name = "${local.codebuild_basename}-tf-plan"
  }
}

resource "aws_codebuild_project" "codebuild_tf_apply" {
  name          = "${local.codebuild_basename}-tf-apply"
  build_timeout = "10"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    modes = []
    type  = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = false
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      encryption_disabled = false
      status              = "DISABLED"
    }
  }

  vpc_config {
    vpc_id = module.vpc.id

    subnets = module.vpc.private_subnets.ids

    security_group_ids = [
      aws_security_group.codebuild.id
    ]
  }

  source {
    buildspec           =  templatefile("files/buildspec-tf-plan.tftpl", {
      gh_pat_secret_name = local.gh_pat_secret_name
    })
    git_clone_depth     = 1
    insecure_ssl        = false
    report_build_status = false
    type                = "GITHUB"
    location            = local.gh_repository
    git_submodules_config {
      fetch_submodules = false
    }
  }

  tags = {
    Name = "${local.codebuild_basename}-tf-apply"
  }
}

resource "aws_cloudwatch_log_group" "codebuild_tf_plan" {
  name              = "/aws/codebuild/${aws_codebuild_project.codebuild_tf_plan.name}"
  retention_in_days = 3

  tags = {
    Name = aws_codebuild_project.codebuild_tf_plan.name
  }
}

resource "aws_cloudwatch_log_group" "codebuild_tf_apply" {
  name              = "/aws/codebuild/${aws_codebuild_project.codebuild_tf_apply.name}"
  retention_in_days = 3

  tags = {
    Name = aws_codebuild_project.codebuild_tf_apply.name
  }
}
