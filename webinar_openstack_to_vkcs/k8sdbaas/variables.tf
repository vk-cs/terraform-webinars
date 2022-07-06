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

variable "DB_USER_PASSWORD" {
  type = string
  sensitive = true
}

variable "db-instance-flavor" {
  type    = string
  default = "Standard-2-4-40"
}

variable "k8s_master-flavor" {
  type    = string
  default = "Standard-2-4-40"
}

variable "k8s_worker-flavor" {
  type    = string
  default = "Basic-1-2-20"
}

variable "k8s_master-volume_type" {
  type    = string
  default = "high-iops"
}

variable "k8s_worker-volume_type" {
  type    = string
  default = "high-iops"
}

variable "k8s-version" {
  type    = string
  default = "1.21.4" 
}