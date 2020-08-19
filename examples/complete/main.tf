provider "aws" {
  region = var.region
}

module "vpc" {
  source      = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.16.1"
  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  name        = var.name
  cidr_block  = "172.16.0.0/16"
}

resource "aws_route53_zone" "private_dns_zone" {
  name = var.domain
  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

module "ses" {
  source        = "../../"
  enabled       = true
  namespace     = var.namespace
  environment   = var.environment
  stage         = var.stage
  name          = var.name
  domain        = var.domain
  zone_id       = aws_route53_zone.private_dns_zone.zone_id
  verify_dkim   = var.verify_dkim
  verify_domain = var.verify_domain
}
