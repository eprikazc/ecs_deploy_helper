variable "region" {
  type = string
  default = "eu-central-1"
}

variable "ecr_repo_host" {
  type = string
  default = "381040904611.dkr.ecr.eu-central-1.amazonaws.com"
}

variable "web_server_repo_name" {
  type = string
  default = "splunk_server"
}

variable "web_server_port" {
  type = number
  default = 8000
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
