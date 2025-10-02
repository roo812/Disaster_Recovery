# resource "aws_s3_bucket" "state" {
#   provider = aws.primary
#   bucket   = "my-terraform-state-bucket"
# }

# resource "aws_s3_bucket_versioning" "state" {
#   provider = aws.primary
#   bucket   = aws_s3_bucket.state.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_replication_configuration" "state" {
#   provider = aws.primary
#   bucket   = aws_s3_bucket.state.id
#   role     = aws_iam_role.replication.arn
#     rule {
#     id     = "replicate-to-secondary"
#     status = "Enabled"

#     destination {
#       bucket        = aws_s3_bucket.state_secondary.arn
#       storage_class = "STANDARD"
#     }
#   }
# }

# resource "aws_s3_bucket" "state_secondary" {
#   provider = aws.secondary
#   bucket   = "my-terraform-state-bucket-secondary"
# }

# resource "aws_s3_bucket_versioning" "state_secondary" {
#   provider = aws.secondary
#   bucket   = aws_s3_bucket.state_secondary.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_iam_role" "replication" {
#   provider = aws.primary
#   name     = "s3-replication-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Principal = {
#           Service = "s3.amazonaws.com"
#         }
#         Effect = "Allow"
#       },
#     ]
#   })
# }

# resource "aws_iam_role_policy" "replication" {
#   provider = aws.primary
#   name     = "s3-replication-policy"
#   role     = aws_iam_role.replication.id
#   policy   = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "s3:GetReplicationConfiguration",
#           "s3:ListBucket"
#         ]
#         Effect   = "Allow"
#         Resource = aws_s3_bucket.state.arn
#       },
#       {
#         Action = [
#           "s3:GetObjectVersion",
#           "s3:GetObjectVersionAcl"
#         ]
#         Effect   = "Allow"
#         Resource = "${aws_s3_bucket.state.arn}/*"
#       },
#       {
#         Action = [
#           "s3:ReplicateObject",
#           "s3:ReplicateDelete"
#         ]
#         Effect   = "Allow"
#         Resource = "${aws_s3_bucket.state_secondary.arn}/*"
#       }
#     ]
#   })
# }