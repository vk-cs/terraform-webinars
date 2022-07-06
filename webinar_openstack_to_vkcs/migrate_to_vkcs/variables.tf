variable "username" {
  type = string
}

variable "password" {
  type = string
  sensitive = true
}

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}