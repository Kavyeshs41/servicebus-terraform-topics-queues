data "azurerm_servicebus_namespace" "main" {
  name                = var.existing_servicebus_name
  resource_group_name = var.resource_group_name
}