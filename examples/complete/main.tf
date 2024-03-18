provider "aws" {
  region = var.region
}

provider "awsutils" {
  region = var.region
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "2.1.1"

  ipv4_primary_cidr_block = "172.16.0.0/16"

  context = module.this.context
}

resource "aws_route53_zone" "private_dns_zone" {
  name = var.domain
  vpc {
    vpc_id = module.vpc.vpc_id
  }
  tags = module.this.tags
}

module "ses" {
  source = "../../"

  domain        = var.domain
  zone_id       = aws_route53_zone.private_dns_zone.zone_id
  verify_dkim   = var.verify_dkim
  verify_domain = var.verify_domain

  context = module.this.context
}
