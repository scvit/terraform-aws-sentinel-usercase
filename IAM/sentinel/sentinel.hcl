# Enforcement_level = "advisory", "soft-mandatory", "hard-mandatory"
# advisory :			 알림 기능
# soft-mandatory : 정책 위반시 fail 알림, 제한적으로 override 하여 인프라 생성 가능 
# hard-mandatory : 정책 위반시 fail 알림, 인프라 생성 불가능

module "tfplan-functions" {
  source = "./tfplan-functions.sentinel"                  # 리소스 탐지 모듈 경로 
}

policy "check-iam-password-complexity" {
  source = "./check-iam-password-complexity.sentinel"     # 정책 파일 경로
  enforcement_level = "soft-mandatory"                    # 정책 적용 레벨 
}

policy "check-iam-password-expiration" {
  source = "./check-iam-password-expiration.sentinel"     # 정책 파일 경로
  enforcement_level = "soft-mandatory"                    # 정책 적용 레벨 
}

policy "check-iam-password-reuse-count" {
  source = "./check-iam-password-reuse-count.sentinel"    # 정책 파일 경로
  enforcement_level = "soft-mandatory"                    # 정책 적용 레벨 
}