resource "azurerm_web_application_firewall_policy" "waf" {
  #checkov:skip=CKV_AZURE_135:OWASP rule set may be enabled elsewhere
  name                = var.waf_policy_name
  resource_group_name = var.resource_group_name
  location            = var.location

  policy_settings {
    enabled                     = var.enabled
    mode                        = var.mode
    request_body_check          = var.request_body_check
    file_upload_limit_in_mb     = var.file_upload_limit_in_mb
    max_request_body_size_in_kb = var.max_request_body_size_in_kb

    dynamic "log_scrubbing" {
      for_each = var.log_scrubbing != null ? [var.log_scrubbing] : []

      content {
        enabled = log_scrubbing.value["enabled"]

        dynamic "rule" {
          for_each = { for k in log_scrubbing.value["rules"] : k.name => k if k != null }

          content {
            enabled                 = rule.value["enabled"]
            match_variable          = rule.value["match_variable"]
            selector_match_operator = rule.value["selector_match_operator"]
            selector                = rule.value["selector"]
          }
        }
      }
    }
  }

  dynamic "custom_rules" {
    for_each = { for k in var.custom_rules : k.name => k if k != null }

    content {
      name      = custom_rules.value["name"]
      action    = custom_rules.value["action"]
      priority  = custom_rules.value["priority"]
      rule_type = custom_rules.value["type"]

      dynamic "match_conditions" {
        for_each = { for k in custom_rules.value["match_conditions"] : k.name => k if k != null }

        content {
          operator           = match_conditions.value["operator"]
          negation_condition = match_conditions.value["negation_condition"]
          match_values       = match_conditions.value["match_values"]
          transforms         = match_conditions.value["transforms"]
          dynamic "match_variables" {
            for_each = { for k in match_conditions.value["match_variables"] : "${k.name}-${k.selector}" => k }

            content {
              variable_name = match_variables.value["name"]
              selector      = match_variables.value["selector"]
            }
          }
        }
      }
    }
  }

  dynamic "managed_rules" {
    for_each = var.managed_rules != null ? [var.managed_rules] : []

    content {

      dynamic "exclusion" {
        for_each = { for k in managed_rules.value["exclusions"] : k.name => k if k != null }

        content {
          match_variable          = exclusion.value["match_variable"]
          selector_match_operator = exclusion.value["operator"]
          selector                = exclusion.value["selector"]

          dynamic "excluded_rule_set" {
            for_each = { for k in exclusion.value["excluded_rule_sets"] : k.name => k if k != null }

            content {
              type    = excluded_rule_set.value["type"]
              version = excluded_rule_set.value["version"]

              dynamic "rule_group" {
                for_each = { for k in excluded_rule_set.value["rule_groups"] : k.name => k if k != null }

                content {
                  rule_group_name = rule_group.value["rule_group_name"]
                  excluded_rules  = rule_group.value["excluded_rules"]
                }
              }
            }
          }
        }
      }

      dynamic "managed_rule_set" {
        for_each = { for k in managed_rules.value["managed_rule_sets"] : k.name => k if k != null }

        content {
          type    = managed_rule_set.value["type"]
          version = managed_rule_set.value["version"]

          dynamic "rule_group_override" {
            for_each = { for k in managed_rule_set.value["rule_group_overrides"] : k.name => k if k != null }

            content {
              rule_group_name = rule_group_override.value["rule_group_name"]

              dynamic "rule" {
                for_each = { for k in rule_group_override.value["rules"] : k.name => k if k != null }

                content {
                  id      = rule.value["id"]
                  enabled = rule.value["enabled"]
                  action  = rule.value["action"]
                }
              }
            }
          }
        }
      }
    }
  }

  tags = var.tags
}
