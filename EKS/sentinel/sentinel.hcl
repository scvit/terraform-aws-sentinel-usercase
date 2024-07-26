# Enforcement_level = "advisory", "soft-mandatory", "hard-mandatory"
module "tfplan-functions" {
  source = "./tfplan-functions.sentinel"
}

policy "check-eks-secrets-encryption" {
  source = "./check-eks-secrets-encryption.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "check-eks-endpoint-private" {
  source = "./check-eks-endpoint-private.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "check-eks-security-group" {
  source = "./check-eks-security-group.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "check-eks-node-group-located-private" {
  source = "./check-eks-node-group-located-private.sentinel"
  enforcement_level = "soft-mandatory"
}