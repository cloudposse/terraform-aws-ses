## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.0 |
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
| smtp\_password | The SMTP password. This will be written to the state file in plain text. |
| smtp\_user | The SMTP user which is access key ID. |
| user\_arn | The ARN assigned by AWS for this user. |
| user\_name | Normalized IAM user name. |
| user\_unique\_id | The unique ID assigned by AWS. |

