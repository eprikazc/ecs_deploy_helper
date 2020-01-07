resource "aws_ecs_cluster" "splunk_ecs" {
  name = "splunk"
}

resource "aws_ecs_service" "splunk-service" {
  name = "splunk-service"
  cluster = aws_ecs_cluster.splunk_ecs.id
  task_definition = aws_ecs_task_definition.service.arn
  desired_count = 1
  launch_type = "FARGATE"
  network_configuration {
    assign_public_ip = true
    subnets = data.aws_subnet_ids.default.ids
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.splunk_public.arn
    container_name = "splunk_public_container"
    container_port = var.web_server_port
  }
  depends_on = [
    aws_lb.app_lb
  ]
}

resource "aws_ecs_task_definition" "service" {
  family = "service"
  container_definitions = templatefile(
    "task-definitions/service.json",
    {
      image: "${var.ecr_repo_host}/${var.splunk_repo_name}:latest",
      region: var.region,
      web_server_port: var.web_server_port
    })
  network_mode = "awsvpc"
  memory = 512
  cpu = 256
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = "arn:aws:iam::381040904611:role/ecsTaskExecutionRole"
}
