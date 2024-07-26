# Enforcement_level = "advisory", "soft-mandatory", "hard-mandatory"
module "tfplan-functions" {
  source = "./tfplan-functions.sentinel"
}

policy "check-ecr-private" {
  source = "./check-ecr-private.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "check-ecr-scanning" {
  source = "./check-ecr-scanning.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "check-ecr-encription" {
  source = "./check-ecr-encription.sentinel"
  enforcement_level = "soft-mandatory"
}