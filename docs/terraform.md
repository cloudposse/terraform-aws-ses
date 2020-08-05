## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0, < 0.14.0 |
| aws | ~> 2.0 |
| null | ~> 2.0 |
| template | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attributes | Additional attributes (\_e.g.\_ "1") | `list(string)` | `[]` | no |
| delimiter | Delimiter between `namespace`, `stage`, `name` and `attributes` | `string` | `"-"` | no |
| domain | The domain to create the SES identity for. | `string` | n/a | yes |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `true` | no |
| iam\_permissions | Specifies permissions for the IAM user. | `list(string)` | <pre>[<br>  "ses:SendRawEmail"<br>]</pre> | no |
| name | Name of the application | `string` | n/a | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | `string` | `""` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | `string` | `""` | no |
| tags | Additional tags (\_e.g.\_ { BusinessUnit : ABC }) | `map(string)` | `{}` | no |
| verify\_dkim | If provided the module will create Route53 DNS records used for DKIM verification. | `bool` | `false` | no |
| verify\_domain | If provided the module will create Route53 DNS records used for domain verification. | `bool` | `false` | no |
| zone\_id | Route53 parent zone ID. If provided (not empty), the module will create Route53 DNS records used for verification | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| access\_key\_id | The SMTP user which is access key ID. |
| secret\_access\_key | The IAM secret for usage with SES API. This will be written to the state file in plain text. |
| ses\_domain\_identity\_arn | The ARN of the SES domain identity. |
| ses\_domain\_identity\_verification\_token | A code which when added to the domain as a TXT record will signal to SES that the owner of the domain has authorised SES to act on their behalf. The domain identity will be in state 'verification pending' until this is done. See below for an example of how this might be achieved when the domain is hosted in Route 53 and managed by Terraform. Find out more about verifying domains in Amazon SES in the AWS SES docs. |
| ses\_smtp\_password | The SMTP password. This will be written to the state file in plain text. |
| user\_arn | The ARN assigned by AWS for this user. |
| user\_name | Normalized IAM user name. |
| user\_unique\_id | The unique ID assigned by AWS. |

