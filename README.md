# AWS Static Website

This terraform module will create a static website hosted on an S3 bucket and served by Cloudfront.

## Usage
Exemple:

```hcl
module "my_website" {
  source = "github.com/alexis974/aws-static-website"

  aws_region       = "eu-west-3"
  domain_name      = "my_domain.fr"
  subdomain_name   = "my_site."
  default_document = "index.html"
}
```
