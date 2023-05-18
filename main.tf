locals {

  configure_script = templatefile("${path.module}/templates/configureNexus.sh.tpl",
    {
      ebs_data_volume = var.ebs_data_volume
      export         = var.ebs_data_volume ? "null" : aws_efs_file_system.this[0].id
      license_secret = var.license_secret
      mount_point    = "/opt/nexus/sonatype-work"
      region         = data.aws_region.current.name
      volume_id      = var.ebs_data_volume ? aws_ebs_volume.data[0].id : "null"
    }
  )
}

data "aws_region" "current" {
}

data "template_cloudinit_config" "this" {

  part {
    filename = "text/x-shellscript"
    content  = local.configure_script
  }

  part {
    content_type = "text/x-shellscript"
    content      = var.asg_additional_user_data
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix               = var.name
  desired_capacity          = var.asg_desired_capacity
  health_check_grace_period = 600
  health_check_type         = "ELB"
  force_delete              = false
  launch_configuration      = aws_launch_configuration.this.name
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  wait_for_capacity_timeout = "15m"
  vpc_zone_identifier       = var.asg_subnets

  target_group_arns = concat(
    var.asg_additional_target_group_arns,
    [aws_lb_target_group.this.arn],
    aws_lb_target_group.additional_this.*.arn
  )

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
  tag {
    key                 = "VolumeKey"
    propagate_at_launch = true
    value               = var.volume_key
  }

  dynamic "tag" {
    for_each = var.tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_ebs_volume" "data" {
  count = var.ebs_data_volume ? 1 : 0

  availability_zone = var.availability_zone
  size              = var.ebs_volume_size

  tags = merge(var.tags,
    {
      Name      = var.volume_key,
      VolumeKey = var.volume_key
    }
  )
}

resource "aws_launch_configuration" "this" {
  name_prefix                 = var.name
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.this.id
  image_id                    = var.ami_id
  instance_type               = var.asg_instance_type
  key_name                    = var.asg_key_name
  user_data_base64            = data.template_cloudinit_config.this.rendered

  security_groups = concat(
    var.asg_additional_security_groups,
    [aws_security_group.this.id, ],
  )

  root_block_device {
    encrypted   = var.root_volume_encryption
    volume_type = var.root_volume_type
    volume_size = var.root_volume_size
  }
  lifecycle {
    create_before_destroy = true
  }
}
