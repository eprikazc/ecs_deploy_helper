resource "aws_lb" "app_lb" {
  name = "app-lb"
  subnets = data.aws_subnet_ids.default.ids
  security_groups = [
    aws_security_group.public_web.id,
    data.aws_security_group.default.id
  ]
}

resource "aws_lb_target_group" "web_app_tg" {
  name = "web-app-tg"
  port = var.web_server_port
  target_type = "ip"
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id
  health_check {
    healthy_threshold = 2
    timeout = 5
    path = var.healtcheck_path
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web_app_tg.arn
  
  }
}
