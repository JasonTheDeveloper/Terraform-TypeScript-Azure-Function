resource "azurerm_function_app" "example" {
  name                      = var.name
  location                  = var.resource_group_location
  resource_group_name       = var.resource_group_name
  app_service_plan_id       = var.app_service_id
  storage_connection_string = var.storage_primary_string
  version                   = "~3"
  app_settings = merge(
    {
      FUNCTIONS_WORKER_RUNTIME = var.runtime
      FUNCTION_APP_EDIT_MODE   = "readwrite"
      HASH                     = base64encode(filesha256(var.functionapp))
      WEBSITE_RUN_FROM_PACKAGE = "https://${var.storage_account_name}.blob.core.usgovcloudapi.net/${var.storage_container_name}/${var.storage_blob_name}${var.sas}"
    },
    var.extra
  )
}
