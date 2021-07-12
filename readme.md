# Azure Servicebus topics, topic subscription and queues with Terraform.

## This module will not create servicebus namespace. It will create resources in existing namespace only.

---
## Example to Use <br />

```main.tf```
```
module "servicebus_topics_queues" {
  source                   = "github.com/Kavyeshs41/servicebus-terraform-topics-queues?ref=0.1"
  topics                   = var.servicebus_topics
  queues                   = var.servicebus_queues
  resource_group_name      = var.resource_group_name
  existing_servicebus_name = var.existing_servicebus_name
}
```

```terraform.tfvars```

```
resource_group_name      = "my-resource-group"
existing_servicebus_name = "my-existing-servicebus-name"

servicebus_topics = [
  {
    name                                    = "dev-tftest-topic"
    enable_partitioning                     = true
    enable_ordering                         = false
    enable_duplicate_detection              = true
    default_message_ttl                     = "P1D"
    max_size                                = 1024
    enable_batched_operations               = true
    duplicate_detection_history_time_window = "P1D"
    
    authorization_rules = [
      {
        name   = "FullAccess"
        rights = ["manage", "send", "listen"]
      },
      {
        name   = "SendOnly"
        rights = ["send"]
      },
      {
        name   = "ListenOnly"
        rights = ["listen"]
      }
    ]
    subscriptions = [
      {
        name                                        = "examplesub"
        max_delivery_count                          = 10
        default_message_ttl                         = "P1D"
        enable_batched_operations                   = true
        enable_dead_lettering_on_message_expiration = true
      }
    ]
  }
]

servicebus_queues = [
  {
    name                                    = "dev-tftest-queue"
    enable_partitioning                     = true
    enable_batched_operations               = false
    default_message_ttl                     = "P1D"
    duplicate_detection_history_time_window = "P1D"
    enable_express                          = false
    lock_duration                           = "PT1M"
    max_size_in_megabytes                   = 1024
    authorization_rules = [
      {
        name   = "FullAccess"
        rights = ["manage", "send", "listen"]
      },
      {
        name   = "SendOnly"
        rights = ["send"]
      },
      {
        name   = "ListenOnly"
        rights = ["listen"]
      }
    ]
  }
]
```
