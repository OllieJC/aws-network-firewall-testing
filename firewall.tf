// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

resource "aws_networkfirewall_firewall_policy" "anfw_policy" {
  name = "firewall-policy"
  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.allow_domains.arn
    }
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.allow_database_access.arn
    }
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.deny_all.arn
    }
  }

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-policy-${var.test_case}"
    },
  )
}

resource "aws_networkfirewall_rule_group" "allow_database_access" {
  capacity = 1
  name     = "allow-database-access"
  type     = "STATEFUL"
  rule_group {
    rules_source {
      stateful_rule {
        action = "PASS"
        header {
          destination      = "ANY"
          destination_port = "5432"
          direction        = "ANY"
          protocol         = "TCP"
          source           = "ANY"
          source_port      = "ANY"
        }
        rule_option {
          keyword = "sid:50"
        }
      }
    }
  }

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-rule-database-${var.test_case}"
    },
  )
}

resource "aws_networkfirewall_rule_group" "allow_domains" {
  capacity = 100
  name     = "allow-domains"
  type     = "STATEFUL"
  rule_group {
    rule_variables {
      ip_sets {
        key = "HOME_NET"
        ip_set {
          definition = [aws_vpc.main.cidr_block]
        }
      }
    }
    rules_source {
      rules_source_list {
        generated_rules_type = "ALLOWLIST"
        target_types         = ["HTTP_HOST", "TLS_SNI"]
        targets              = var.allowed_https_domains
      }
    }
  }

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-rule-domains-${var.test_case}"
    },
  )
}

resource "aws_networkfirewall_rule_group" "deny_all" {
  capacity = 1
  name     = "deny-all"
  type     = "STATEFUL"
  rule_group {
    rules_source {
      stateful_rule {
        action = "DROP"
        header {
          destination      = "ANY"
          destination_port = "ANY"
          direction        = "ANY"
          protocol         = "IP"
          source           = "ANY"
          source_port      = "ANY"
        }
        rule_option {
          keyword = "sid:999"
        }
      }
    }
  }

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-rule-deny-${var.test_case}"
    },
  )
}

resource "aws_networkfirewall_firewall" "anfw" {
  name                = "NetworkFirewall"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.anfw_policy.arn
  vpc_id              = aws_vpc.main.id

  dynamic "subnet_mapping" {
    for_each = aws_subnet.fw-a.id

    content {
      subnet_id = subnet_mapping.value
    }
  }

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-${var.test_case}"
    },
  )
}

resource "aws_cloudwatch_log_group" "anfw_alert_log_group" {
  name = "/aws/network-firewall/alert"
}

resource "aws_networkfirewall_logging_configuration" "anfw_alert_logging_configuration" {
  firewall_arn = aws_networkfirewall_firewall.anfw.arn
  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.anfw_alert_log_group.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }
  }
}
