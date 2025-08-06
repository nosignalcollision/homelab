variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare zone ID"
}

variable "domain_name" {
  type        = string
  description = "Domain name"
}

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

resource "cloudflare_dns_record" "mx1" {
  type     = "MX"
  zone_id  = var.cloudflare_zone_id
  name     = var.domain_name
  proxied  = false
  content  = "in1-smtp.messagingengine.com"
  priority = 10
  ttl      = 1
}

resource "cloudflare_dns_record" "mx2" {
  type     = "MX"
  zone_id  = var.cloudflare_zone_id
  name     = var.domain_name
  proxied  = false
  content  = "in2-smtp.messagingengine.com"
  priority = 20
  ttl      = 1
}

resource "cloudflare_dns_record" "dkim" {
  for_each = toset(["1", "2", "3"])
  type     = "CNAME"
  proxied  = false
  zone_id  = var.cloudflare_zone_id
  name     = "fm${each.key}._domainkey.${var.domain_name}"
  content  = "fm${each.key}.${var.domain_name}.dkim.fmhosted.com"
  ttl      = 1
}

resource "cloudflare_dns_record" "spf" {
  type    = "TXT"
  zone_id = var.cloudflare_zone_id
  name    = var.domain_name
  content = "\"v=spf1 include:spf.messagingengine.com -all\""
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "dmarc" {
  type    = "TXT"
  zone_id = var.cloudflare_zone_id
  name    = "_dmarc.${var.domain_name}"
  content = "\"v=DMARC1; p=none;\""
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "mail_cname" {
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id
  name    = "mail.${var.domain_name}"
  content = "fastmail.com"
  proxied = false
  ttl     = 1
}
