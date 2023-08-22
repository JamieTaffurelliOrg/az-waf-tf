variable "resource_group_name" {
  type        = string
  description = "Resource Group name to deploy to"
}

variable "waf_policy_name" {
  type        = string
  description = "Name of the WAF Policy"
}

variable "location" {
  type        = string
  description = "Location of the WAF Policy"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Enable the WAF policy"
}

variable "mode" {
  type        = string
  default     = "Prevention"
  description = "WAF mode, Detection or Prevention"
}

variable "request_body_check" {
  type        = bool
  default     = true
  description = "Enable inspection of request body"
}

variable "file_upload_limit_in_mb" {
  type        = number
  default     = 100
  description = "The File Upload Limit in MB. Accepted values are in the range 1 to 4000"
}

variable "max_request_body_size_in_kb" {
  type        = number
  default     = 128
  description = "The Maximum Request Body Size in KB. Accepted values are in the range 8 to 2000."
}

variable "log_scrubbing" {
  type = object(
    {
      enabled = optional(bool, true)
      rules = optional(list(object({
        enabled                 = optional(bool, true)
        match_variable          = string
        selector_match_operator = optional(string, "Equals")
        selector                = optional(list(string))
      })))
    }
  )
  default     = null
  description = " WAF Policy custom rules"
}

variable "custom_rules" {
  type = list(object(
    {
      name     = string
      action   = string
      priority = number
      type     = string
      match_conditions = list(object({
        name               = string
        operator           = string
        negation_condition = optional(bool, false)
        match_values       = list(string)
        transforms         = optional(list(string))
        match_variables = optional(list(object({
          name     = string
          selector = optional(string)
        })))
      }))
    }
  ))
  default     = []
  description = " WAF Policy custom rules"
}

variable "managed_rules" {
  type = object(
    {
      exclusions = optional(list(object(
        {
          name           = string
          match_variable = string
          operator       = string
          selector       = string
          excluded_rule_sets = list(object({
            name    = string
            type    = optional(string, "OWASP")
            version = optional(string, "3.2")
            rule_groups = optional(list(object({
              name            = string
              rule_group_name = string
              excluded_rules  = list(string)
            })))
          }))
      })), [])
      managed_rule_sets = optional(list(object({
        name    = string
        type    = string
        version = string
        rule_group_overrides = optional(list(object({
          name            = string
          rule_group_name = string
          rules = optional(list(object({
            name    = string
            id      = string
            enabled = optional(bool, true)
            action  = string
          })))
        })), [])
      })))
  })
  description = " WAF Policy managed rules"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply"
}
