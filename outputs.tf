# ---------------------------------------------------------------- Outputs --- #

output "cloudfront_status" {
  value = aws_cloudfront_distribution.website.status
}

output "s3_bucket_name" {
  value = aws_s3_bucket.website.bucket
}

output "website_url" {
  value = "https://${aws_route53_record.website.fqdn}"
}