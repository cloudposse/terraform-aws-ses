/*
Create SES domain identity and verify it with Route53 DNS records
*/

resource "aws_ses_domain_identity" "ses_domain" {
  count = module.this.enabled ? 1 : 0

  domain = var.domain
}

resource "aws_route53_record" "amazonses_verification_record" {
  count = module.this.enabled && var.verify_domain ? 1 : 0

  zone_id = var.zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = "600"
  records = [join("", aws_ses_domain_identity.ses_domain.*.verification_token)]
}

resource "aws_ses_domain_dkim" "ses_domain_dkim" {
  count = module.this.enabled ? 1 : 0

  domain = join("", aws_ses_domain_identity.ses_domain.*.domain)
}

resource "aws_route53_record" "amazonses_dkim_record" {
  count = module.this.enabled && var.verify_dkim ? 3 : 0

  zone_id = var.zone_id
  name    = "${element(aws_ses_domain_dkim.ses_domain_dkim.0.dkim_tokens, count.index)}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.ses_domain_dkim.0.dkim_tokens, count.index)}.dkim.amazonses.com"]
}


/*
Create user with permissions to send emails from SES domain
*/
module "ses_user" {
  source  = "cloudposse/iam-system-user/aws"
  version = "0.20.2"
  enabled = var.ses_user_enabled

  context = module.this.context
}

data "aws_iam_policy_document" "ses_user_policy" {
  count = var.ses_user_enabled ? 1 : 0

  statement {
    actions   = var.iam_permissions
    resources = [join("", aws_ses_domain_identity.ses_domain.*.arn)]
  }
}

resource "aws_iam_user_policy" "sending_emails" {
  #bridgecrew:skip=BC_AWS_IAM_16:Skipping `Ensure IAM policies are attached only to groups or roles` check because this module intentionally attaches IAM policy directly to a user.
  count = var.ses_user_enabled ? 1 : 0

  name   = module.this.id
  policy = join("", data.aws_iam_policy_document.ses_user_policy.*.json)
  user   = module.ses_user.user_name
}
