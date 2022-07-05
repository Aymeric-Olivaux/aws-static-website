# --- Bucket Section --- #

# ----------------------------------------------------------------- Bucket --- #

resource "aws_s3_bucket" "website" {
  bucket        = "${var.subdomain_name}${var.domain_name}"
  force_destroy = true

  tags = {
    Terraform = "true"
  }
}


# ----------------------------------------------------------------- Access --- #

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}