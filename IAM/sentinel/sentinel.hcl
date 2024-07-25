# Enforcement_level = "advisory", "soft-mandatory", "hard-mandatory"
module "tfplan-functions" {
  source = "./tfplan-functions.sentinel"
}

policy "check-iam-password-complexity" {
  source = "./check-iam-password-complexity.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "check-iam-password-expiration" {
  source = "./check-iam-password-expiration.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "check-iam-password-reuse-count" {
  source = "./check-iam-password-reuse-count.sentinel"
  enforcement_level = "soft-mandatory"
}