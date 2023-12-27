resource "aws_s3_bucket" "s3_static_web_server" {
  bucket = "salesync.site"
}

resource "aws_s3_bucket_website_configuration" "s3_static_web_server" {
  bucket = aws_s3_bucket.s3_static_web_server.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_versioning" "s3_static_web_server" {
  bucket = aws_s3_bucket.s3_static_web_server.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_ownership_controls" "s3_static_web_server" {
  bucket = aws_s3_bucket.s3_static_web_server.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_static_web_server" {
  bucket = aws_s3_bucket.s3_static_web_server.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "s3_static_web_server" {
  depends_on = [
    aws_s3_bucket_ownership_controls.s3_static_web_server,
    aws_s3_bucket_public_access_block.s3_static_web_server,
  ]

  bucket = aws_s3_bucket.s3_static_web_server.id
  acl    = "public-read"
}


output "website_url" {
  value = "http://${aws_s3_bucket.s3_static_web_server.bucket}.s3-website.ap-northeast-2.amazonaws.com"
}