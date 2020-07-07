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

output "user_secret" {
  sensitive   = true
  value       = module.ses_user.secret
  description = "The IAM secret for usage with SES API. This will be written to the state file in plain text."
}

# https://docs.aws.amazon.com/ses/latest/DeveloperGuide/smtp-credentials.html
output "smtp_password" {
  sensitive   = true
  value       = module.ses_user.ses_smtp_password
  description = "The SMTP password. This will be written to the state file in plain text."
}

output "smtp_user" {
  value       = module.ses_user.access_key_id
  description = "The SMTP user which is access key ID."
}
