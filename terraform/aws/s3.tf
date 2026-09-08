resource "aws_s3_bucket" "backend" {
  bucket_prefix = "${var.project_name}-backend-"
  tags = {
    Name = "${var.project_name}-backend"
  }
}

resource "aws_s3_bucket_public_access_block" "backend" {
  bucket = aws_s3_bucket.backend.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "backend_config" {
  bucket = aws_s3_bucket.backend.id
  key = "config.json"
  source = "${path.module}/config.json"
  content_type = "application/json"
}