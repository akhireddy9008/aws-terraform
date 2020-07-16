#S3 Bucket to store state files of all worksapces
resource "aws_s3_bucket" "terraform_state" {
  count  = "${terraform.workspace == "dev" ? 1 : 0}"
  bucket = var.s3_bucket_state_file
  #versioning is enabled to store old state files
  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = true
  }
  #Enable Server side encryption
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  tags = {
    Name        = var.s3_bucket_state_file
    Environment = "all"
  }
}

#Dynamo DB table for locking state file
resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  count          = "${terraform.workspace == "dev" ? 1 : 0}"
  name           = var.backend_dynamodb_table
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name        = var.backend_dynamodb_table
    Environment = "all"
    Description = "DynamoDB Table for Locking Terraform State"
  }

