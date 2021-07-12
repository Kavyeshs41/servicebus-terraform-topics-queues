resource "azurerm_servicebus_topic" "main" {
  count = length(local.topics)

  namespace_name      = var.existing_servicebus_name
  resource_group_name = var.resource_group_name

  name                         = local.topics[count.index].name
  status                       = local.topics[count.index].status
  enable_express               = local.topics[count.index].enable_express
  support_ordering             = local.topics[count.index].enable_ordering
  default_message_ttl          = local.topics[count.index].default_message_ttl
  enable_partitioning          = local.topics[count.index].enable_partitioning
  auto_delete_on_idle          = local.topics[count.index].auto_delete_on_idle
  max_size_in_megabytes        = local.topics[count.index].max_size
  enable_batched_operations    = local.topics[count.index].enable_batched_operations
  requires_duplicate_detection = local.topics[count.index].enable_duplicate_detection

  duplicate_detection_history_time_window = local.topics[count.index].duplicate_detection_history_time_window
}

resource "azurerm_servicebus_topic_authorization_rule" "main" {
  count = length(local.topic_authorization_rules)

  namespace_name      = var.existing_servicebus_name
  resource_group_name = var.resource_group_name
 
  name                = local.topic_authorization_rules[count.index].name
  topic_name          = local.topic_authorization_rules[count.index].topic_name

  listen = contains(local.topic_authorization_rules[count.index].rights, "listen") ? true : false
  send   = contains(local.topic_authorization_rules[count.index].rights, "send") ? true : false
  manage = contains(local.topic_authorization_rules[count.index].rights, "manage") ? true : false

  depends_on = [azurerm_servicebus_topic.main]
}

resource "azurerm_servicebus_subscription" "main" {
  count = length(local.topic_subscriptions)

  namespace_name      = var.existing_servicebus_name
  resource_group_name = var.resource_group_name

  name       = local.topic_subscriptions[count.index].name
  status     = local.topic_subscriptions[count.index].status
  topic_name = local.topic_subscriptions[count.index].topic_name

  forward_to                = local.topic_subscriptions[count.index].forward_to
  lock_duration             = local.topic_subscriptions[count.index].lock_duration
  requires_session          = local.topic_subscriptions[count.index].enable_session
  max_delivery_count        = local.topic_subscriptions[count.index].max_delivery_count
  auto_delete_on_idle       = local.topic_subscriptions[count.index].auto_delete_on_idle
  default_message_ttl       = local.topic_subscriptions[count.index].default_message_ttl
  enable_batched_operations = local.topic_subscriptions[count.index].enable_batched_operations

  forward_dead_lettered_messages_to         = local.topic_subscriptions[count.index].forward_dead_lettered_messages_to
  dead_lettering_on_message_expiration      = local.topic_subscriptions[count.index].enable_dead_lettering_on_message_expiration
  dead_lettering_on_filter_evaluation_error = local.topic_subscriptions[count.index].enabled_dead_lettering_on_filter_evaluation_error

  depends_on = [azurerm_servicebus_topic.main]
}

resource "azurerm_servicebus_subscription_rule" "main" {
  count = length(local.topic_subscription_rules)

  namespace_name      = var.existing_servicebus_name
  resource_group_name = var.resource_group_name
 
  name                = local.topic_subscription_rules[count.index].name
  action              = local.topic_subscription_rules[count.index].action
  sql_filter          = local.topic_subscription_rules[count.index].sql_filter
  topic_name          = local.topic_subscription_rules[count.index].topic_name
  filter_type         = local.topic_subscription_rules[count.index].sql_filter != "" ? "SqlFilter" : null
  subscription_name   = local.topic_subscription_rules[count.index].subscription_name

  depends_on = [azurerm_servicebus_subscription.main]
}