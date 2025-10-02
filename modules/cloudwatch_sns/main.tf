resource "aws_sns_topic" "alerts" {
  provider = aws.primary
  name     = "dr-alerts"
}

resource "aws_sns_topic_subscription" "email" {
  provider = aws.primary
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.sns_email
}

# Aurora replication lag alarm (primary region)
resource "aws_cloudwatch_metric_alarm" "db_replication_lag" {
  provider            = aws.primary
  alarm_name          = "db-replication-lag"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "AuroraGlobalDBReplicationLag"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 60  # Seconds
  alarm_actions       = [aws_sns_topic.alerts.arn]
  dimensions = {
    GlobalClusterIdentifier = var.aurora_cluster_id
  }
}

# # S3 replication failure alarm (check in primary)
# resource "aws_cloudwatch_metric_alarm" "s3_replication_fail" {
#   provider            = aws.primary
#   alarm_name          = "s3-replication-failure"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = 1
#   metric_name         = "ReplicationFailedObjectCount"
#   namespace           = "AWS/S3"
#   period              = 300
#   statistic           = "Sum"
#   threshold           = 0
#   alarm_actions       = [aws_sns_topic.alerts.arn]
#   dimensions = {
#     BucketName = var.s3_bucket
#   }
# }