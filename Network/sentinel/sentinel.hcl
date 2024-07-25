# Enforcement_level = "advisory", "soft-mandatory", "hard-mandatory"
module "tfplan-functions" {
  source = "./tfplan-functions.sentinel"
}

policy "check-public-ip-on-private-subnet" {
  source = "./check-public-ip-on-private-subnet.sentinel"
  enforcement_level = "soft-mandatory"
}