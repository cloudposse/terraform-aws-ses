#-----------------------------------------------------------------------------------------------------------------------
# OPTIONALLY CREATE A USER AND GROUP WITH PERMISSIONS TO SEND EMAILS FROM SES domain
#-----------------------------------------------------------------------------------------------------------------------
locals {
  enabled = module.this.enabled

  create_group_enabled = local.enabled && var.ses_group_enabled
  create_user_enabled  = local.enabled && var.ses_user_enabled

  ses_group_name = local.create_group_enabled ? coalesce(var.ses_group_name, module.this.id) : null
}

# Create SES domain identity and verify it with Route53 DNS records
resource "aws_ses_domain_identity" "ses_domain" {
  count = local.enabled ? 1 : 0

  domain = var.domain
}

resource "aws_route53_record" "amazonses_verification_record" {
  count = local.enabled && var.verify_domain ? 1 : 0

  zone_id = var.zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = "600"
  records = [join("", aws_ses_domain_identity.ses_domain.*.verification_token)]
}

resource "aws_ses_domain_dkim" "ses_domain_dkim" {
  count = local.enabled ? 1 : 0

  domain = join("", aws_ses_domain_identity.ses_domain.*.domain)
}

resource "aws_route53_record" "amazonses_dkim_record" {
  count = local.enabled && var.verify_dkim ? 3 : 0

  zone_id = var.zone_id
  name    = "${element(aws_ses_domain_dkim.ses_domain_dkim.0.dkim_tokens, count.index)}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.ses_domain_dkim.0.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

data "aws_iam_policy_document" "ses_policy" {
  count = local.enabled ? 1 : 0

  statement {
    actions   = var.iam_permissions
    resources = concat(aws_ses_domain_identity.ses_domain.*.arn, var.iam_allowed_resources)
  }
}

module "role" {
  source  = "cloudposse/iam-role/aws"
  version = "0.13.0"

  enabled = ! local.create_user_enabled

  policy_description = "Allow SES access"
  role_description   = "IAM role with permissions to perform actions on SES resources"

  policy_documents = [
    join("", data.aws_iam_policy_document.ses_policy.*.json),
  ]

  context = module.this.context
}

resource "aws_iam_group" "ses_users" {
  count = local.create_group_enabled ? 1 : 0

  name = local.ses_group_name
  path = var.ses_group_path
}

resource "aws_iam_group_policy" "ses_group_policy" {
  count = local.create_group_enabled ? 1 : 0

  name  = module.this.id
  group = aws_iam_group.ses_users[0].name

  policy = join("", data.aws_iam_policy_document.ses_policy.*.json)
}

resource "aws_iam_user_group_membership" "ses_user" {
  count = local.create_group_enabled && local.create_user_enabled ? 1 : 0

  user = module.ses_user.user_name

  groups = [
    aws_iam_group.ses_users[0].name
  ]
}

module "ses_user" {
  source  = "cloudposse/iam-system-user/aws"
  version = "0.22.5"
  enabled = local.create_user_enabled

  context = module.this.context
}

resource "aws_iam_user_policy" "sending_emails" {
  #bridgecrew:skip=BC_AWS_IAM_16:Skipping `Ensure IAM policies are attached only to groups or roles` check because this module intentionally attaches IAM policy directly to a user.
  count = local.create_user_enabled && ! local.create_group_enabled ? 1 : 0

  name   = module.this.id
  policy = join("", data.aws_iam_policy_document.ses_policy.*.json)
  user   = module.ses_user.user_name
}
