variable "domain" {
  description = "The domain to create the SES identity for."
  type        = string
}

variable "zone_id" {
  type        = string
  description = "Route53 parent zone ID. If provided (not empty), the module will create Route53 DNS records used for verification"
  default     = ""
}

variable "verify_domain" {
  type        = bool
  description = "If provided the module will create Route53 DNS records used for domain verification."
  default     = false
}

variable "verify_dkim" {
  type        = bool
  description = "If provided the module will create Route53 DNS records used for DKIM verification."
  default     = false
}

variable "create_spf_record" {
  type        = bool
  description = "If provided the module will create an SPF record for `domain`."
  default     = false
}

variable "custom_from_subdomain" {
  type        = list(string)
  description = "If provided the module will create a custom subdomain for the `From` address."
  default     = []
  nullable    = false

  validation {
    condition     = length(var.custom_from_subdomain) <= 1
    error_message = "Only one custom_from_subdomain is allowed."
  }

  validation {
    condition     = length(var.custom_from_subdomain) > 0 ? can(regex("^[a-zA-Z0-9-]+$", var.custom_from_subdomain[0])) : true
    error_message = "The custom_from_subdomain must be a valid subdomain."
  }
}

variable "custom_from_behavior_on_mx_failure" {
  type        = string
  description = "The behaviour of the custom_from_subdomain when the MX record is not found. Defaults to `UseDefaultValue`."
  default     = "UseDefaultValue"

  validation {
    condition     = contains(["UseDefaultValue", "RejectMessage"], var.custom_from_behavior_on_mx_failure)
    error_message = "The custom_from_behavior_on_mx_failure must be `UseDefaultValue` or `RejectMessage`."
  }
}

variable "custom_from_dns_record_enabled" {
  type        = bool
  description = "If enabled the module will create a Route53 DNS record for the `From` address subdomain."
  default     = true
}

variable "iam_permissions" {
  type        = list(string)
  description = "Specifies permissions for the IAM user."
  default     = ["ses:SendRawEmail"]
}

variable "iam_allowed_resources" {
  type        = list(string)
  description = "Specifies resource ARNs that are enabled for `var.iam_permissions`. Wildcards are acceptable."
  default     = []
}

variable "iam_access_key_max_age" {
  type        = number
  description = "Maximum age of IAM access key (seconds). Defaults to 30 days. Set to 0 to disable expiration."
  default     = 2592000

  validation {
    condition     = var.iam_access_key_max_age >= 0
    error_message = "The iam_access_key_max_age must be 0 (disabled) or greater."
  }
}

variable "ses_group_enabled" {
  type        = bool
  description = "Creates a group with permission to send emails from SES domain"
  default     = true
}

variable "ses_group_name" {
  type        = string
  description = "The name of the IAM group to create. If empty the module will calculate name from a context (recommended)."
  default     = ""
}

variable "ses_group_path" {
  type        = string
  description = "The IAM Path of the group to create"
  default     = "/"
}

variable "ses_user_enabled" {
  type        = bool
  description = "Creates user with permission to send emails from SES domain"
  default     = true
}
