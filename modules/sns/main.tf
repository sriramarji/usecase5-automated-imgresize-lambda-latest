resource "aws_sns_topic" "image_resizing" {
  name = var.topic_name
}



resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.image_resizing.arn
  protocol  = "email"
  endpoint  = var.notification_email  # email address to receive notifications
}

