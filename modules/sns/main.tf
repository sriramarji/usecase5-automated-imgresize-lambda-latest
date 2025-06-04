# modules/sns/main.tf
resource "aws_sns_topic" "image_processing_topic" {
  name = "image-processing-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.image_processing_topic.arn
  protocol  = "email"
  endpoint  = "stakeholder@example.com"
}
