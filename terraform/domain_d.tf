variable "domain_d" {
  type = string
}

variable "domain_d_cloudflare_account_id" {
  type = string
}

variable "domain_d_cloudflare_api_token" {
  type      = string
  sensitive = true
}

provider "cloudflare" {
  alias     = "domain_d"
  api_token = var.domain_d_cloudflare_api_token
}

resource "cloudflare_zone" "domain_d" {
  provider = cloudflare.domain_d
  account = {
    id = var.domain_d_cloudflare_account_id
  }
  name = var.domain_d
  type = "full"
}

module "domain_d_fastmail" {
  source             = "./modules/fastmail"
  cloudflare_zone_id = cloudflare_zone.domain_d.id
  domain_name        = cloudflare_zone.domain_d.name
  providers = {
    cloudflare = cloudflare.domain_d
  }
}
