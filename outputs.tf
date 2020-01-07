output "lb_dns_name" {
  value = "http://${aws_lb.app_lb.dns_name}"
}
output "default_subnet" {
  value = data.aws_subnet_ids.default.ids
}
output "cluster_arn" {
  value = aws_ecs_cluster.cluster1.id
}
output "service_arn" {
  value = aws_ecs_service.web_server.id
}
output "task_definition_arn" {
  value = aws_ecs_task_definition.web_app.id
}
