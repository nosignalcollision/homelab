variable "domain_c" {
  type = string
}

variable "domain_c_cloudflare_account_id" {
  type = string
}

variable "domain_c_cloudflare_api_token" {
  type      = string
  sensitive = true
}

provider "cloudflare" {
  alias     = "domain_c"
  api_token = var.domain_c_cloudflare_api_token
}

resource "cloudflare_zone" "domain_c" {
  provider = cloudflare.domain_c
  account = {
    id = var.domain_c_cloudflare_account_id
  }
  name = var.domain_c
  type = "full"
}

module "domain_c_fastmail" {
  source             = "./modules/fastmail"
  cloudflare_zone_id = cloudflare_zone.domain_c.id
  domain_name        = cloudflare_zone.domain_c.name
  providers = {
    cloudflare = cloudflare.domain_c
  }
}
