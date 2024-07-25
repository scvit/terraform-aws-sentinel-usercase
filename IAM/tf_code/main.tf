# IAM 패스워드 정책 리소스 생성
resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = 8
  require_lowercase_characters   = true
  require_numbers                = true
  require_uppercase_characters   = false # 필요에 따라 true로 변경 가능
  require_symbols                = true
  allow_users_to_change_password = true

  # 최근 사용한 패스워드 재사용 방지
  password_reuse_prevention = 2 # 최근 2개의 패스워드 재사용 방지

  # 추가 보안을 위한 선택적 설정
  max_password_age = 91   # 패스워드 만료 기간 (일)
  hard_expiry      = true # 만료된 패스워드 변경 강제
}