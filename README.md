# az-waf-tf
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.69.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_web_application_firewall_policy.waf](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/web_application_firewall_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_custom_rules"></a> [custom\_rules](#input\_custom\_rules) | WAF Policy custom rules | <pre>list(object(<br>    {<br>      name     = string<br>      action   = string<br>      priority = number<br>      type     = string<br>      match_conditions = list(object({<br>        name               = string<br>        operator           = string<br>        negation_condition = optional(bool, false)<br>        match_values       = list(string)<br>        transforms         = optional(list(string))<br>        match_variables = optional(list(object({<br>          name     = string<br>          selector = optional(string)<br>        })))<br>      }))<br>    }<br>  ))</pre> | `[]` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enable the WAF policy | `bool` | `true` | no |
| <a name="input_file_upload_limit_in_mb"></a> [file\_upload\_limit\_in\_mb](#input\_file\_upload\_limit\_in\_mb) | The File Upload Limit in MB. Accepted values are in the range 1 to 4000 | `number` | `100` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of the WAF Policy | `string` | n/a | yes |
| <a name="input_log_scrubbing"></a> [log\_scrubbing](#input\_log\_scrubbing) | WAF Policy custom rules | <pre>object(<br>    {<br>      enabled = optional(bool, true)<br>      rules = optional(list(object({<br>        enabled                 = optional(bool, true)<br>        match_variable          = string<br>        selector_match_operator = optional(string, "Equals")<br>        selector                = optional(list(string))<br>      })))<br>    }<br>  )</pre> | `null` | no |
| <a name="input_managed_rules"></a> [managed\_rules](#input\_managed\_rules) | WAF Policy managed rules | <pre>object(<br>    {<br>      exclusions = optional(list(object(<br>        {<br>          name           = string<br>          match_variable = string<br>          operator       = string<br>          selector       = string<br>          excluded_rule_sets = list(object({<br>            name    = string<br>            type    = optional(string, "OWASP")<br>            version = optional(string, "3.2")<br>            rule_groups = optional(list(object({<br>              name            = string<br>              rule_group_name = string<br>              excluded_rules  = list(string)<br>            })))<br>          }))<br>      })))<br>      managed_rule_sets = optional(list(object({<br>        name    = string<br>        type    = string<br>        version = string<br>        rule_group_overrides = optional(list(object({<br>          name            = string<br>          rule_group_name = string<br>          rules = optional(list(object({<br>            name    = string<br>            id      = string<br>            enabled = optional(bool, true)<br>            action  = string<br>          })))<br>        })))<br>      })))<br>  })</pre> | n/a | yes |
| <a name="input_max_request_body_size_in_kb"></a> [max\_request\_body\_size\_in\_kb](#input\_max\_request\_body\_size\_in\_kb) | The Maximum Request Body Size in KB. Accepted values are in the range 8 to 2000. | `number` | `128` | no |
| <a name="input_mode"></a> [mode](#input\_mode) | WAF mode, Detection or Prevention | `string` | `"Prevention"` | no |
| <a name="input_request_body_check"></a> [request\_body\_check](#input\_request\_body\_check) | Enable inspection of request body | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group name to deploy to | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply | `map(string)` | n/a | yes |
| <a name="input_waf_policy_name"></a> [waf\_policy\_name](#input\_waf\_policy\_name) | Name of the WAF Policy | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
