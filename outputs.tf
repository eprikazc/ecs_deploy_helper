output "lb_dns_name" {
  value = "http://${aws_lb.app_lb.dns_name}"
}
output "default_subnet" {
  value = data.aws_subnet_ids.default.ids
}
