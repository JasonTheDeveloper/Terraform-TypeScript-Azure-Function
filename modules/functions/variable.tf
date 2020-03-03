variable "name" {
  type = string
}

variable "functionapp" {
  type = string
}

variable "storage_primary_string" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "storage_container_name" {
  type = string
}

variable "storage_blob_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "app_service_id" {
  type = string
}

variable "sas" {
  type = string
}

variable "runtime" {
  type = string
}

variable "extra" {
  type    = map
  default = {}
}
