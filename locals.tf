locals {
  authorization_rules = [
    for rule in var.authorization_rules : merge({
      name   = ""
      rights = []
    }, rule)
  ]

  topics = [
    for topic in var.topics : merge({
      name                       = ""
      status                     = "Active"
      auto_delete_on_idle        = null
      default_message_ttl        = null
      enable_batched_operations  = null
      enable_express             = null
      enable_partitioning        = null
      max_size                   = null
      enable_duplicate_detection = null
      enable_ordering            = null
      authorization_rules        = []
      subscriptions              = []

      duplicate_detection_history_time_window = null
    }, topic)
  ]

  topic_authorization_rules = flatten([
    for topic in local.topics : [
      for rule in topic.authorization_rules : merge({
        name   = ""
        rights = []
        }, rule, {
        topic_name = topic.name
      })
    ]
  ])

  topic_subscriptions = flatten([
    for topic in local.topics : [
      for subscription in topic.subscriptions :
      merge({
        name                      = ""
        status                    = "Active"
        auto_delete_on_idle       = null
        default_message_ttl       = null
        lock_duration             = null
        enable_batched_operations = null
        max_delivery_count        = null
        enable_session            = null
        forward_to                = null
        rules                     = []

        forward_dead_lettered_messages_to                 = null
        enable_dead_lettering_on_message_expiration       = null
        enabled_dead_lettering_on_filter_evaluation_error = null
        }, subscription, {
        topic_name = topic.name
      })
    ]
  ])

  topic_subscription_rules = flatten([
    for subscription in local.topic_subscriptions : [
      for rule in subscription.rules : merge({
        name       = ""
        sql_filter = ""
        action     = ""
        }, rule, {
        topic_name        = subscription.topic_name
        subscription_name = subscription.name
      })
    ]
  ])

  queues = [
    for queue in var.queues : merge({
      name                                    = ""
      status                                  = "Active"
      auto_delete_on_idle                     = null
      default_message_ttl                     = null
      enable_express                          = false
      enable_partitioning                     = false
      lock_duration                           = "PT1M"
      max_size                                = 1024
      enable_duplicate_detection              = false
      enable_session                          = false
      max_delivery_count                      = 10
      max_size_in_megabytes                   = 1024
      duplicate_detection_history_time_window = null
      authorization_rules                     = []
      enable_batched_operations               = false
      forward_to                              = null
      forward_dead_lettered_messages_to       = null

      enable_dead_lettering_on_message_expiration       = false
      enabled_dead_lettering_on_filter_evaluation_error = true
      duplicate_detection_history_time_window           = null
    }, queue)
  ]

  queue_authorization_rules = flatten([
    for queue in local.queues : [
      for rule in queue.authorization_rules : merge({
        name   = ""
        rights = []
        }, rule, {
        queue_name = queue.name
      })
    ]
  ])
}