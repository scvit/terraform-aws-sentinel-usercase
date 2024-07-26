# Enforcement_level = "advisory", "soft-mandatory", "hard-mandatory"
module "tfplan-functions" {
  source = "./tfplan-functions.sentinel"
}

policy "check-lambda-vpc-config" {
  source = "./check-lambda-vpc-config.sentinel"
  enforcement_level = "soft-mandatory"
}