resource "aws_iam_role" "ec2" {
  name = "ec2-app-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      },
    ]
  })
}

resource "aws_iam_role_policy" "ec2_s3" {
  name = "ec2-s3-access"
  role = aws_iam_role.ec2.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${var.app_bucket}/*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2" {
  name = "ec2-app-profile"
  role = aws_iam_role.ec2.name
}