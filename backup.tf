data "aws_iam_policy_document" "assume_backup" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "backup" {
  count              = var.enable_efs_backups ? 1 : 0
  name_prefix        = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_backup.json
  tags               = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "backup" {
  count      = var.enable_efs_backups ? 1 : 0
  role       = aws_iam_role.backup[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_backup_vault" "this" {
  count = var.enable_efs_backups ? 1 : 0
  name  = var.efs_backup_vault_name
  tags  = var.tags
}

# AWS Backup plan
resource "aws_backup_plan" "this" {
  count = var.enable_efs_backups ? 1 : 0
  name  = "${var.name} backup"
  tags  = var.tags

  rule {
    rule_name         = "${var.name} EFS backup"
    schedule          = var.efs_backup_schedule
    target_vault_name = var.efs_backup_vault_name
    lifecycle {
      delete_after = var.efs_backup_retain_days
    }
  }
}

resource "aws_backup_selection" "this" {
  count        = var.enable_efs_backups ? 1 : 0
  name         = "${var.name}-EFS-backup"
  iam_role_arn = aws_iam_role.backup[0].arn
  plan_id      = aws_backup_plan.this[0].id
  resources    = [aws_efs_file_system.this.arn]

}
