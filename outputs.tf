output "ecr_url" {
  value = aws_ecr_repository.splunk_server.repository_url
}

output "lb_dns_name" {
  value = aws_lb.app_lb.dns_name
}
