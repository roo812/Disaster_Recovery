output "primary_alb_dns" {
  value = module.alb_primary.alb_dns
}

output "secondary_alb_dns" {
  value = module.alb_secondary.alb_dns
}

output "route53_name_servers" {
  value = module.route53.name_servers
  description = "Update these in GoDaddy for roovi.shop"
}

output "aurora_primary_endpoint" {
  value = module.aurora.primary_endpoint
}

output "aurora_secondary_endpoint" {
  value = module.aurora.secondary_endpoint
}