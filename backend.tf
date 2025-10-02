terraform {
  backend "s3" {
    bucket         = "roovi-terraform-state"  # existing
    key            = "dr-project/terraform.tfstate"
    region         = "us-east-1"  # Primary region
    #dynamodb_table = "terraform-locks"  
}
}

resource "aws_dynamodb_table" "terraform_locks" {
  name           = "terraform-locks"
  billing_mode   = "PAY_PER_REQUEST"

  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "TerraformLocks"
  }
}
