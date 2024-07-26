# KMS 키 생성 (ECR 이미지 암호화용)
resource "aws_kms_key" "ecr_key" {
  description             = "KMS key for ECR image encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

# ECR 리포지토리 생성
resource "aws_ecr_repository" "main" {
  name                 = "my-ecr-repo"
  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.ecr_key.arn
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}

# ECR 리포지토리 정책 설정 (프라이빗 접근 설정)
resource "aws_ecr_repository_policy" "main_policy" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowPushPull"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]
      }
    ]
  })
}

# 현재 AWS 계정 ID 조회
data "aws_caller_identity" "current" {}

# ECR 수명 주기 정책 설정 (옵션: 오래된 이미지 자동 삭제)
resource "aws_ecr_lifecycle_policy" "main_lifecycle_policy" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus     = "any"
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}