terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.8.0"
    }
  }
}


# Default Region
provider "aws" {
  alias = "eu_west_3"
  region = "eu-west-3"
}