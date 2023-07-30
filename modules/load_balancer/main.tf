resource "aws_security_group" "alb" {
  vpc_id = var.vpc_id
  name = lookup(var.tags, "Name", null)
  dynamic "ingress" {
    for_each = var.security_group_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

resource "aws_lb" "load_balancer" {
  name                       = "app-loadbalancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb.id]
  subnets                    = var.subnets
  enable_deletion_protection = false
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}


resource "aws_lb_target_group" "alb_target_group" {
  name     = "alb-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    port = 8080
    healthy_threshold = 2
    timeout = 5
    matcher = "403"
  }
}

resource "aws_lb_target_group_attachment" "attach_private_instance" {
  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = var.target_id
}


