output "lb_dns_name" {
  value = "http://${aws_lb.app_lb.dns_name}"
}
