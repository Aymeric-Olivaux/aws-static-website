# --- ACM Section --- #

# ------------------------------------------------------------- CloudFront --- #

# This creates an SSL certificate
resource "aws_acm_certificate" "cert" {
  provider = aws.us_east_1

  domain_name = "${var.website_prefix}${var.zone_name}"

  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Terraform = "True"
  }
}

# This is a DNS record for the ACM certificate validation to prove we own the domain
resource "aws_route53_record" "dns_cert_validation" {
  provider = aws.us_east_1

  allow_overwrite = true
  name            = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.public_zone.id
  ttl             = 60
}

# This tells terraform to cause the route53 validation to happen
resource "aws_acm_certificate_validation" "cert_validation" {
  provider = aws.us_east_1

  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.dns_cert_validation.fqdn]
}
