resource "aws_route53_zone" "main" {
  name = var.domain_name
}

resource "aws_route53_health_check" "primary" {
  fqdn              = var.primary_alb_dns
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
}

resource "aws_route53_record" "failover_primary" {
  zone_id         = aws_route53_zone.main.zone_id
  name            = "test.${var.domain_name}"
  type            = "A"
  alias {
    name                   = "dualstack.${var.primary_alb_dns}"
    zone_id                = var.primary_alb_zone
    evaluate_target_health = true
  }
  failover_routing_policy {
    type = "PRIMARY"
  }
  set_identifier = "primary"
  health_check_id = aws_route53_health_check.primary.id
}

resource "aws_route53_record" "failover_secondary" {
  zone_id         = aws_route53_zone.main.zone_id
  name            = "test.${var.domain_name}"
  type            = "A"
  alias {
    name                   = "dualstack.${var.secondary_alb_dns}"
    zone_id                = var.secondary_alb_zone
    evaluate_target_health = true
  }
  failover_routing_policy {
    type = "SECONDARY"
  }
  set_identifier = "secondary"
  health_check_id = aws_route53_health_check.secondary.id
}

resource "aws_route53_health_check" "secondary" {
  fqdn              = var.secondary_alb_dns
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
}

output "name_servers" {
  value = aws_route53_zone.main.name_servers
}