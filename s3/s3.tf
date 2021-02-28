resource "aws_s3_bucket" "lambda" {
  bucket              = "function-${var.environment}-${var.region}"
  acl                 = "private"
  acceleration_status = "Enabled"
  force_destroy       = false

  versioning {
    # enabled = true

    mfa_delete = var.enable_mfa_delete

  }

  tags = {
    State = "Function Bucket for terraform in ${var.region}"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  count = length(var.allowed_accounts_read_access) > 0 ? 1 : 0

  bucket = aws_s3_bucket.lambda.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow access to state s3 bucket",
      "Action": [
        "s3:GetBucketLocation",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.lambda.id}",
      "Principal": {
        "AWS": ${jsonencode(var.allowed_accounts_read_access)}
      }
    },
    {
      "Sid": "Allow access to objects in the state s3 bucket",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.lambda.id}/*",
      "Principal": {
        "AWS": ${jsonencode(var.allowed_accounts_read_access)}
      }
    }
  ]
}
EOF

}

resource "aws_s3_bucket_public_access_block" "state_block" {
   bucket = aws_s3_bucket.lambda.id

   block_public_acls       = true
   block_public_policy     = true
   ignore_public_acls      = true
   restrict_public_buckets = true

}

# Upload an object
resource "aws_s3_bucket_object" "object" {

  bucket = "function-${var.environment}-${var.region}"

  key    = "${var.app-version}/${var.filename}"

  acl    = "private"  # or can be "public-read"

  source = var.filename

  etag = filemd5("${var.filename}")

  depends_on = [aws_s3_bucket.lambda]

}