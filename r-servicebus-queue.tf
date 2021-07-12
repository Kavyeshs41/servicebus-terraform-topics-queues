resource "azurerm_servicebus_queue" "main" {
  count = length(local.queues)

  resource_group_name = var.resource_group_name
  namespace_name      = var.existing_servicebus_name

  name                                 = local.queues[count.index].name
  status                               = local.queues[count.index].status
  forward_to                           = local.queues[count.index].forward_to
  lock_duration                        = local.queues[count.index].lock_duration
  enable_express                       = local.queues[count.index].enable_express
  requires_session                     = local.queues[count.index].enable_session
  max_delivery_count                   = local.queues[count.index].max_delivery_count
  enable_partitioning                  = local.queues[count.index].enable_partitioning
  auto_delete_on_idle                  = local.queues[count.index].auto_delete_on_idle
  default_message_ttl                  = local.queues[count.index].default_message_ttl
  max_size_in_megabytes                = local.queues[count.index].max_size
  requires_duplicate_detection         = local.queues[count.index].enable_duplicate_detection
  forward_dead_lettered_messages_to    = local.queues[count.index].forward_dead_lettered_messages_to
  dead_lettering_on_message_expiration = local.queues[count.index].enable_dead_lettering_on_message_expiration

  duplicate_detection_history_time_window = local.queues[count.index].duplicate_detection_history_time_window
}

resource "azurerm_servicebus_queue_authorization_rule" "main" {
  count = length(local.queue_authorization_rules)

  namespace_name      = var.existing_servicebus_name
  resource_group_name = var.resource_group_name

  name                = local.queue_authorization_rules[count.index].name
  queue_name          = local.queue_authorization_rules[count.index].queue_name

  listen = contains(local.queue_authorization_rules[count.index].rights, "listen") ? true : false
  send   = contains(local.queue_authorization_rules[count.index].rights, "send") ? true : false
  manage = contains(local.queue_authorization_rules[count.index].rights, "manage") ? true : false

  depends_on = [azurerm_servicebus_queue.main]
}