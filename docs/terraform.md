## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (_e.g._ "1") | list(string) | `<list>` | no |
| delimiter | Delimiter between `namespace`, `stage`, `name` and `attributes` | string | `-` | no |
| domain | The domain to create the SES identity for. | string | - | yes |
| enabled | Set to false to prevent the module from creating any resources | bool | `true` | no |
| name | Name of the application | string | - | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | string | `` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | `` | no |
| tags | Additional tags (_e.g._ { BusinessUnit : ABC }) | map(string) | `<map>` | no |
| verify_dkim | If provided the module will create Route53 DNS records used for DKIM verification. | bool | `false` | no |
| verify_domain | If provided the module will create Route53 DNS records used for domain verification. | bool | `false` | no |
| zone_id | Route53 parent zone ID. If provided (not empty), the module will create Route53 DNS records used for verification | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| access_key_id | The access key ID |
| secret_access_key | The secret access key. This will be written to the state file in plain-text |
| user_arn | The ARN assigned by AWS for this user |
| user_name | Normalized IAM user name |
| user_unique_id | The unique ID assigned by AWS |

