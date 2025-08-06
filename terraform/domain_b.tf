variable "domain_b" {
  type = string
}

variable "domain_b_cloudflare_account_id" {
  type = string
}

variable "domain_b_cloudflare_api_token" {
  type      = string
  sensitive = true
}

provider "cloudflare" {
  alias     = "domain_b"
  api_token = var.domain_b_cloudflare_api_token
}

resource "cloudflare_zone" "domain_b" {
  provider = cloudflare.domain_b
  account = {
    id = var.domain_b_cloudflare_account_id
  }
  name = var.domain_b
  type = "full"
}

module "domain_b_fastmail" {
  source             = "./modules/fastmail"
  cloudflare_zone_id = cloudflare_zone.domain_b.id
  domain_name        = cloudflare_zone.domain_b.name
  providers = {
    cloudflare = cloudflare.domain_b
  }
}
