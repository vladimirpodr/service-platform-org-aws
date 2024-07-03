

resource "aws_iam_user" "circleci" {
  name = local.circleci_basename

  tags = {
    Name = local.circleci_basename
  }
}

resource "aws_iam_user_policy" "circleci_org_publish_ecr" {
  name = "org-publish-ecr"
  user = aws_iam_user.circleci.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:BatchGetImage",
                "ecr:GetLifecyclePolicy",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:ListTagsForResource",
                "ecr:DescribeImageScanFindings",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:PutImage",
                "ecr:CreateRepository"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy" "circleci_eks_describe_clusters" {
  name = "eks-describe-clusters"
  user = aws_iam_user.circleci.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:DescribeCluster",
                "eks:ListClusters"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy" "circleci_s3_ds_tensorflow_models_readonly" {
  name = "s3-ds-tensorflow-models-readonly"
  user = aws_iam_user.circleci.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::ds-tensorflow-models.org.io"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::ds-tensorflow-models.org.io/*"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy" "circleci_s3_kubeless_functions_artifacts_write" {
  name = "s3-kubeless-functions-artifacts-write"
  user = aws_iam_user.circleci.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::functions.org.io"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "arn:aws:s3:::functions.org.io/*"
        }
    ]
}
EOF
}
