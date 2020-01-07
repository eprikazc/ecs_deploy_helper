resource "aws_lb" "app_lb" {
  name = "app-lb"
  subnets = data.aws_subnet_ids.default.ids
  security_groups = [
    aws_security_group.public_web.id,
    data.aws_security_group.default.id
  ]
}

resource "aws_lb_target_group" "splunk_public" {
  name = "splunk-public"
  port = var.web_server_port
  target_type = "ip"
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id
  health_check {
    healthy_threshold = 2
    timeout = 5
    path = "/health"
  }
}

resource "aws_lb_listener" "splunk_public" {
  load_balancer_arn = aws_lb.app_lb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.splunk_public.arn
  
  }
}
