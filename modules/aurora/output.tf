output "global_cluster_id" {
  value = aws_rds_global_cluster.main.id
}

output "primary_endpoint" {
  value = aws_rds_cluster.primary.endpoint
}

output "secondary_endpoint" {
  value = aws_rds_cluster.secondary.endpoint
}

# output "primary_db_endpoint" {
#   value = aws_rds_cluster.primary.endpoint
# }

# output "secondary_db_endpoint" {
#   value = aws_rds_cluster.secondary.endpoint
# }