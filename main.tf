# ------------------------------------------------------------------- Data --- #

data "aws_route53_zone" "aws_zone" {
  name = "${var.subdomain_name}${var.domain_name}."
}
