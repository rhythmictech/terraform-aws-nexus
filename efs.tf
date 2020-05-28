locals {
  efs_name = "${var.name}-efs"

  efs_tags = merge(
    var.tags,
    {
      "Name" = local.efs_name
    },
  )
}

resource "aws_security_group" "efs" {
  name_prefix = local.efs_name
  tags        = local.efs_tags
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 2049
    protocol        = "TCP"
    security_groups = concat([aws_security_group.this.id], var.efs_additional_allowed_security_groups)
    to_port         = 2049
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_efs_file_system" "this" {
  encrypted = true
  tags      = local.efs_tags
}

resource "aws_efs_mount_target" "this" {
  count           = length(var.efs_subnets)
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.efs_subnets[count.index]
  security_groups = [aws_security_group.efs.id]
}
