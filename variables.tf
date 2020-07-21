variable "enabled" {
  type        = bool
  description = "Set to false to prevent the module from creating any resources"
  default     = true
}

variable "namespace" {
  type        = string
  description = "Namespace (e.g. `eg` or `cp`)"
  default     = ""
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  default     = ""
}

variable "name" {
  type        = string
  description = "Name of the application"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  description = "Additional attributes (_e.g._ \"1\")"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (_e.g._ { BusinessUnit : ABC })"
  default     = {}
}

variable "domain" {
  description = "The domain to create the SES identity for."
  type        = string
}

variable "zone_id" {
  type        = string
  description = "Route53 parent zone ID. If provided (not empty), the module will create Route53 DNS records used for verification"
  default     = ""
}

variable "verify_route53_domain" {
  type        = bool
  description = "If provided the module will create Route53 DNS records used for domain verification."
  default     = false
}

variable "verify_cloudflare_domain" {
  type        = bool
  description = "If provided the module will create Cloudflare DNS records used for domain verification."
  default     = false
}

variable "verify_dnsimple_domain" {
  type        = bool
  description = "If provided the module will create DNSimple DNS records used for domain verification."
  default     = false
}

variable "verify_route53_dkim" {
  type        = bool
  description = "If provided the module will create Route53 DNS records used for DKIM verification."
  default     = false
}

variable "verify_cloudflare_dkim" {
  type        = bool
  description = "If provided the module will create Cloudflare DNS records used for DKIM verification."
  default     = false
}

variable "verify_dnsimple_dkim" {
  type        = bool
  description = "If provided the module will create DNSimple DNS records used for DKIM verification."
  default     = false
}

variable "iam_permissions" {
  type        = list(string)
  description = "Specifies permissions for the IAM user."
  default     = ["ses:SendRawEmail"]
}
