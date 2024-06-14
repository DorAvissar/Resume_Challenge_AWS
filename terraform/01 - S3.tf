# Create S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucketname
  tags = {
    Name = "cloud-resume-project"
  }
}

resource "aws_s3_bucket_public_access_block" "my_bucket" {
  bucket = aws_s3_bucket.my_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "index.html"
  source = "../website/index.html"
  acl   = "private"
  content_type = "text/html"
}

resource "aws_s3_object" "style" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "style.css"
  source = "../website/style.css"
  acl   = "private"
  content_type = "text/css"
}

resource "aws_s3_object" "index_js" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "index.js"
  source = "../website/index.js"
  acl   = "private"
  content_type = "text/javascript"
}

locals {
  s3_origin_id = "S3-${aws_s3_bucket.my_bucket.id}"
}

resource "aws_cloudfront_origin_access_identity" "example" {
  comment = "OAI for CloudFront to access S3 bucket"
}

resource "aws_iam_user" "cloudfront_dummy_user" {
  name = "cloudfront_dummy_user"
}

resource "aws_iam_access_key" "cloudfront_dummy_user_key" {
  user = aws_iam_user.cloudfront_dummy_user.name
}

resource "aws_iam_policy" "cloudfront_s3_access_policy" {
  name        = "CloudFrontS3AccessPolicy"
  description = "IAM policy for CloudFront to access S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:GetObject"],
        Resource = ["${aws_s3_bucket.my_bucket.arn}/*"],
      },
    ],
  })
}

resource "aws_iam_role" "cloudfront_s3_access_role" {
  name = "CloudFrontS3AccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "cloudfront_s3_access_attachment" {
  policy_arn = aws_iam_policy.cloudfront_s3_access_policy.arn
  role       = aws_iam_role.cloudfront_s3_access_role.name
}

# Create S3 bucket policy based on CloudFront Origin Access Identity (OAI)
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.example.iam_arn,
        },
        Action = "s3:GetObject",
        Resource = ["${aws_s3_bucket.my_bucket.arn}/*"],
      },
    ],
  })
}
