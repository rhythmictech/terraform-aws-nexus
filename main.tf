locals {

  configure_script = templatefile("${path.module}/templates/configureNexus.sh.tpl",
    {
      export         = aws_efs_file_system.this.id
      license_secret = var.license_secret
      mount_point    = "/opt/nexus/sonatype-work"
    }
  )
}

data "template_cloudinit_config" "this" {

  part {
    filename = "text/x-shellscript"
    content  = local.configure_script
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix               = var.name
  desired_capacity          = var.asg_desired_capacity
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = false
  launch_configuration      = aws_launch_configuration.this.name
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  target_group_arns         = [aws_lb_target_group.this.arn]
  wait_for_capacity_timeout = "15m"
  vpc_zone_identifier       = var.asg_subnets

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
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
    [aws_security_group.this.id]
  )

  root_block_device {
    encrypted   = true
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
  }
}
