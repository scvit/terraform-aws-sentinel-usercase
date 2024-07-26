# Enforcement_level = "advisory", "soft-mandatory", "hard-mandatory"
module "tfplan-functions" {
  source = "./tfplan-functions.sentinel"
}

policy "check-ebs-volume-encryption" {
  source = "./check-ebs-volume-encryption.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "check-snapshot-restrict-access.sentinel" {
  source = "./check-snapshot-restrict-access.sentinel"
  enforcement_level = "soft-mandatory"
}