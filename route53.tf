# ------------------------------------------------------------------- Root --- #

resource "aws_route53_record" "website" {
  zone_id = data.aws_route53_zone.aws_zone.zone_id
  name    = "${var.subdomain_name}${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = true
  }
}