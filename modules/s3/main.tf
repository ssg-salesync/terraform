# s3 bucket 생성
resource "aws_s3_bucket" "salesync_site_ex" {
      bucket = "salesync_site_ex"
}

# s3 퍼블릭 엑세스 차단 여부
resource "aws_s3_bucket_public_access_block" "s3_public_access" {
  bucket = aws_s3_bucket.salesync_site_ex.id

  block_public_acls = false
  block_public_policy = false

}

# s3 bucket 정책
resource "aws_s3_bucket_policy" "s3_policy" {
    bucket = aws_s3_bucket.salesync_site_ex.id
    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AddPerm",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::salesync_site_ex/*"
        }
    ]
}
POLICY
}

# s3 정적 웹호스팅
resource "aws_s3_bucket_website_configuration" "s3_web_hosting" {
  bucket = aws_s3_bucket.salesync_site_ex.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}
