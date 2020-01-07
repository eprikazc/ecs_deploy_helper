variable "region" {
  type = string
}

variable "ecr_repo_host" {
  type = string
}
variable "execution_role_arn" {
  type = string
}

variable "web_server_repo_name" {
  type = string
}

variable "web_server_port" {
  type = number
}

variable "DB_NAME" {
  type = string
}

variable "DB_USER" {
  type = string
}

variable "DB_PASSWORD" {
  type = string
}

variable "DB_HOST" {
  type = string
}

variable "DB_PORT" {
  type = string
}
