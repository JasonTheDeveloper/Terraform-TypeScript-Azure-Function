################## Resource Group ##################

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

################## Storage Account ##################

resource "azurerm_storage_account" "sa" {
  name                     = random_string.storage_name.result
  location                 = azurerm_resource_group.rg.resource_group_location
  resource_group_name      = azurerm_resource_group.rg.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "sc" {
  name                  = "function-releases"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "ts" {
  name                   = "functionapp-ts.zip"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.sc.name
  type                   = "block"
  source                 = var.functionapp_ts
}

data "azurerm_storage_account_sas" "access" {
  connection_string = azurerm_storage_account.sa.primary_connection_string
  https_only        = true
  start             = "2019-01-01"
  expiry            = "2021-12-31"
  resource_types {
    object    = true
    container = false
    service   = false
  }
  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }
  permissions {
    read    = true
    write   = false
    delete  = false
    list    = false
    add     = false
    create  = false
    update  = false
    process = false
  }
}

################## Function ##################

resource "azurerm_app_service_plan" "sp" {
  name                = "test-plan"
  resource_group_name = azurerm_resource_group.rg.resource_group_name
  location            = azurerm_resource_group.rg.resource_group_location
  kind                = "FunctionApp"
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

module "ts" {
  source                  = "./modules/functions"
  name                    = "test-function-ts"
  functionapp             = var.functionapp_ts
  storage_primary_string  = azurerm_storage_account.sa.primary_connection_string
  storage_account_name    = azurerm_storage_account.sa.name
  storage_container_name  = azurerm_storage_container.sc.name
  storage_blob_name       = azurerm_storage_blob.ts.name
  resource_group_name     = azurerm_resource_group.rg.resource_group_name
  resource_group_location = azurerm_resource_group.rg.resource_group_location
  app_service_id          = azurerm_app_service_plan.sp.id
  sas                     = data.azurerm_storage_account_sas.access.sas
  runtime                 = "node"
  extra = {
    WEBSITE_NODE_DEFAULT_VERSION = "~12"
  }
}
