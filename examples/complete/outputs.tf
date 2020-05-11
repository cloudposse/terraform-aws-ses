output "access_key_id" {
  value       = module.ses.access_key_id
  description = "The access key ID"
}

output "secret_access_key" {
  sensitive   = true
  value       = module.ses.secret_access_key
  description = "The secret access key. This will be written to the state file in plain-text"
}

output "user_name" {
  value       = module.ses.user_name
  description = "Normalized IAM user name"
}

output "user_unique_id" {
  value       = module.ses.user_unique_id
  description = "The unique ID assigned by AWS"
}
