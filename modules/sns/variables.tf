variable "topic_name" {
  type        = string
  description = "SNS Topic name"
}

variable "notification_email" {
  description = "Email address to subscribe to the SNS topic"
  type        = string
}
