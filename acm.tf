provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

module "website_acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  providers = {
    aws = aws.us-east-1
  }

  domain_name = "${var.subdomain_name}${var.domain_name}"
  zone_id     = data.aws_route53_zone.aws_zone.zone_id

  wait_for_validation = true

  tags = {
    Terraform = "true"
  }
}