variable "domain_a" {
  type = string
}

variable "domain_a_cloudflare_account_id" {
  type = string
}

variable "domain_a_cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "domain_a_gateway_name" {
  type = string
}


provider "cloudflare" {
  alias     = "domain_a"
  api_token = var.domain_a_cloudflare_api_token
}

resource "cloudflare_zone" "domain_a" {
  provider = cloudflare.domain_a
  account = {
    id = var.domain_a_cloudflare_account_id
  }
  name = var.domain_a
  type = "full"
}

resource "cloudflare_dns_record" "gateway" {
  provider = cloudflare.domain_a
  zone_id  = cloudflare_zone.domain_a.id
  type     = "A"
  name     = "${var.domain_a_gateway_name}.${cloudflare_zone.domain_a.name}"
  ttl      = 60
  content  = "0.0.0.0"
  comment  = "Gateway IP address supplied by dynamic DNS."

  proxied = false

  lifecycle {
    ignore_changes = [content]
  }
}
