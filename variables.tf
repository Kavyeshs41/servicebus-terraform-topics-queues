variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "topics" {
  type        = any
  default     = []
  description = "List of topics."
}

variable "authorization_rules" {
  type        = any
  default     = []
  description = "List of namespace authorization rules."
}

variable "queues" {
  type        = any
  default     = []
  description = "List of queues."
}

variable "existing_servicebus_name" {
  type        = string
  description = "existing servicebus name"
}