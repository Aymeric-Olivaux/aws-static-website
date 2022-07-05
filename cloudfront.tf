# ----------------------------------------------------------------- Locals --- #

locals {
  s3_origin_id = "s3-origin"
}


# -------------------------------------------------- Origin Access Control --- #

# Using origin access control (OAC) over deprecated origin access identity (OAI) to
resource "aws_cloudfront_origin_access_control" "s3-origin" {
  name                              = local.s3_origin_id
  description                       = "${local.s3_origin_id} for ${var.subdomain_name}${var.domain_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


# ------------------------------------------------------------- Cloudfront --- #

resource "aws_cloudfront_distribution" "website" {
  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3-origin.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CDN for ${var.subdomain_name}${var.domain_name}"
  default_root_object = var.default_document

  aliases = [aws_s3_bucket.website.id]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 600
    max_ttl                = 3600
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["FR"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = module.website_acm.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  depends_on = [
    aws_s3_bucket.website,
    module.website_acm,
  ]

  wait_for_deployment = true

  tags = {
    Terraform = "True"
  }
}


# ------------------------------------------- Bucket Polify for Cloudfront --- #

data "aws_iam_policy_document" "website" {
  statement {
    sid       = "AllowCloudFrontServicePrincipalReadOnly"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.website.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website.json
}