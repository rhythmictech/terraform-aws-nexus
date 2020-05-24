resource "aws_security_group" "elb" {
  name_prefix = "${var.name}-elb-sg"
  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    map(
      "Name", "${var.name}-elb-sg"
    )
  )
  
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
  }

  egress {
    from_port       = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.this.id]
    to_port         = 80
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "this" {
  name_prefix                      = substr(var.name, 0, 6)
  enable_cross_zone_load_balancing = "true"
  internal                         = var.elb_internal
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.elb.id]
  subnets                          = var.elb_subnets
  tags                             = var.tags
}

resource "aws_lb_listener" "this" {
  certificate_arn   = var.elb_certificate
  load_balancer_arn = aws_lb.this.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    target_group_arn = aws_lb_target_group.this.id
    type             = "forward"
  }
}

resource "aws_lb_target_group" "this" {
  name_prefix = substr(var.name,0,6)
  port        = "80"
  protocol    = "HTTP"
  tags        = var.tags
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold = 2
    interval          = 15
    matcher           = "200-299,302"
    protocol          = "HTTP"
    port              = "80"
  }

  lifecycle {
    create_before_destroy = true
  }
}

