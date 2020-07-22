module "label" {
  source = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"

  attributes = var.attributes
  delimiter  = var.delimiter
  enabled    = var.enabled
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
}

/*
Create SES domain identity and verify it with Route 53, DNSimple or Cloudflare DNS records
*/

resource "aws_ses_domain_identity" "ses_domain" {
  count = var.enabled ? 1 : 0

  domain = var.domain
}

resource "aws_route53_record" "amazonses_verification_record" {
  count = var.enabled && var.verify_route53_domain ? 1 : 0

  zone_id = var.zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = "60"
  records = [join("", aws_ses_domain_identity.ses_domain.*.verification_token)]
}
  
resource "cloudflare_record" "amazonses_verification_record" {
  count = var.enabled && var.verify_cloudflare_domain ? 1 : 0
  
  zone_id = var.zone_id
  name    = "_amazonses.${var.domain}"
  value   = aws_ses_domain_identity.ses_domain.0.verification_token
  type    = "TXT"
  ttl     = "60"
}
  
resource "dnsimple_record" "amazonses_verification_record" {
  count = var.enabled && var.verify_dnsimple_domain ? 1 : 0
  
  domain  = var.domain
  name    = "_amazonses"
  value   = aws_ses_domain_identity.ses_domain.0.verification_token
  type    = "TXT"
  ttl     = "60"
}

resource "aws_ses_domain_dkim" "ses_domain_dkim" {
  count = var.enabled ? 1 : 0

  domain = join("", aws_ses_domain_identity.ses_domain.*.domain)
}

resource "aws_route53_record" "amazonses_dkim_record" {
  count = var.enabled && var.verify_route53_dkim ? 3 : 0

  zone_id = var.zone_id
  name    = "${element(aws_ses_domain_dkim.ses_domain_dkim.0.dkim_tokens, count.index)}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${element(aws_ses_domain_dkim.ses_domain_dkim.0.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource "cloudflare_record" "amazonses_dkim_record" {
  count = var.enabled && var.verify_cloudflare_dkim ? 3 : 0

  zone_id = var.zone_id
  name = format(
    "%s._domainkey.%s",
    element(aws_ses_domain_dkim.ses_domain_dkim.0.dkim_tokens, count.index),
    var.domain,
  )
  type    = "CNAME"
  ttl     = "60"
  value   = "${element(aws_ses_domain_dkim.ses_domain_dkim.0.dkim_tokens, count.index)}.dkim.amazonses.com"
}
  
resource "dnsimple_record" "amazonses_dkim_record" {
  count = var.enabled && var.verify_dnsimple_dkim ? 3 : 0

  domain = var.domain
  name = format(
    "%s._domainkey",
    element(aws_ses_domain_dkim.ses_domain_dkim.0.dkim_tokens, count.index), 
  )
  type    = "CNAME"
  ttl     = "60"
  value   = "${element(aws_ses_domain_dkim.ses_domain_dkim.0.dkim_tokens, count.index)}.dkim.amazonses.com"
}

/*
Create user with permissions to send emails from SES domain
*/
module "ses_user" {
  source = "git::https://github.com/cloudposse/terraform-aws-iam-system-user.git?ref=0.8.0"

  enabled   = var.enabled
  name      = module.label.name
  namespace = var.namespace
  stage     = var.stage
}

data "aws_iam_policy_document" "ses_user_policy" {
  count = var.enabled ? 1 : 0

  statement {
    actions   = var.iam_permissions
    resources = [join("", aws_ses_domain_identity.ses_domain.*.arn)]
  }
}

resource "aws_iam_user_policy" "sending_emails" {
  count = var.enabled ? 1 : 0

  name   = module.label.id
  policy = join("", data.aws_iam_policy_document.ses_user_policy.*.json)
  user   = module.ses_user.user_name
}
