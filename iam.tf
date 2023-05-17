data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ebs" {
  statement {
    actions = ["ec2:AttachVolume"]
    sid     = "AllowEBSAttach"

    resources = [
      "arn:aws:ec2:*:*:instance/*",
      "arn:aws:ec2:*:*:volume/*"
    ]

    condition {
      test     = "StringLike"
      values   = [var.volume_key]
      variable = "ec2:ResourceTag/VolumeKey"
    }
  }
}

resource "aws_iam_policy" "ebs" {
  count = var.ebs_data_volume ? 1 : 0
  name_prefix = var.name

  description = "IAM policy for EBS attachment on Nexus servers"
  path        = "/"
  policy      = data.aws_iam_policy_document.ebs.json
}

resource "aws_iam_role" "this" {
  name_prefix        = var.name
  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags               = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "ebs" {
  count = var.ebs_data_volume ? 1 : 0

  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.ebs[0].arn
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = length(var.asg_additional_iam_policies)
  role       = aws_iam_role.this.name
  policy_arn = var.asg_additional_iam_policies[count.index]
}

resource "aws_iam_instance_profile" "this" {
  name_prefix = var.name
  role        = aws_iam_role.this.name
}
