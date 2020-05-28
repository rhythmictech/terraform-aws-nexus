data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name_prefix        = var.name
  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags               = var.tags

  lifecycle {
    create_before_destroy = true
  }
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
