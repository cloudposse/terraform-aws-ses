output "ses_domain_identity_arn" {
  value       = try(aws_ses_domain_identity.ses_domain[0].arn, "")
  description = "The ARN of the SES domain identity"
}

output "ses_domain_identity_verification_token" {
  value       = try(aws_ses_domain_identity.ses_domain[0].verification_token, "")
  description = "A code which when added to the domain as a TXT record will signal to SES that the owner of the domain has authorised SES to act on their behalf. The domain identity will be in state 'verification pending' until this is done. See below for an example of how this might be achieved when the domain is hosted in Route 53 and managed by Terraform. Find out more about verifying domains in Amazon SES in the AWS SES docs."
}

output "ses_dkim_tokens" {
  value       = try(aws_ses_domain_dkim.ses_domain_dkim.0.dkim_tokens, "")
  description = "A list of DKIM Tokens which, when added to the DNS Domain as CNAME records, allows for receivers to verify that emails were indeed authorized by the domain owner."
}

output "user_name" {
  value       = module.ses_user.user_name
  description = "Normalized IAM user name."
}

output "user_arn" {
  value       = module.ses_user.user_arn
  description = "The ARN assigned by AWS for this user."
}

output "user_unique_id" {
  value       = module.ses_user.user_unique_id
  description = "The unique ID assigned by AWS."
}

output "ses_group_name" {
  value       = local.ses_group_name
  description = "The IAM group name"
}

output "secret_access_key" {
  sensitive   = true
  value       = module.ses_user.secret_access_key
  description = "The IAM secret for usage with SES API. This will be written to the state file in plain text."
}

# https://docs.aws.amazon.com/ses/latest/DeveloperGuide/smtp-credentials.html
output "ses_smtp_password" {
  sensitive   = true
  value       = module.ses_user.ses_smtp_password_v4
  description = "The SMTP password. This will be written to the state file in plain text."
}

output "access_key_id" {
  value       = module.ses_user.access_key_id
  description = "The SMTP user which is access key ID."
}
