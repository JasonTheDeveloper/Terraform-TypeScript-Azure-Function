variable "resource_group_location" {
  type    = string
}

variable "resource_group_name" {
  type    = string
}

variable "functionapp_ts" {
  type    = string
  default = "src/function/typescript/build/functionapp-ts.zip"
}

resource "random_string" "storage_name" {
  length  = 24
  upper   = false
  lower   = true
  number  = true
  special = false
}
