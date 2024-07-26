# VPC 생성
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Main VPC"
  }
}

# 서브넷 생성
resource "aws_subnet" "lambda_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)

  tags = {
    Name = "Lambda Subnet"
  }
}

# Lambda 실행 역할
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Lambda 함수에 VPC 접근 권한 부여
resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Lambda 함수 생성
data "archive_file" "lambda_hello_world" {
  type = "zip"

  source_dir  = "${path.module}/hello-world"
  output_path = "${path.module}/hello-world.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename         = basename(data.archive_file.lambda_hello_world.output_path)
  function_name    = "test_lambda_function"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_hello_world.output_base64sha256
  runtime          = "nodejs20.x"

  vpc_config {
    subnet_ids         = [aws_subnet.lambda_subnet.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}

# Lambda 함수용 보안 그룹
resource "aws_security_group" "lambda_sg" {
  name        = "lambda_sg"
  description = "Security group for Lambda function"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}