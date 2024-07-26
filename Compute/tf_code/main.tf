# VPC 생성
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Main VPC"
  }
}

# 서브넷 생성
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)

  tags = {
    Name = "Main Subnet"
  }
}

# 보안 그룹 생성
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

# IAM 역할 생성
resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# EC2 인스턴스 프로필 생성
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}

# # KMS 키 생성
# resource "aws_kms_key" "ebs_key" {
#   description             = "KMS key for EBS volume encryption"
#   deletion_window_in_days = 10
# }

# EBS 볼륨 생성
resource "aws_ebs_volume" "example" {
  availability_zone = "${var.region}a"
  size              = 40

  encrypted = true
  # kms_key_id = aws_kms_key.ebs_key.arn

  tags = {
    Name = "EncryptedVolume"
  }
}

# EC2 인스턴스 생성
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"

  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
    encrypted   = true # Sentinel 조건
  }

  tags = {
    Name = "ExampleInstance"
  }
}

# EBS 볼륨을 EC2 인스턴스에 연결
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.example.id
}

# EBS 스냅샷 생성
resource "aws_ebs_snapshot" "example_snapshot" {
  volume_id = aws_ebs_volume.example.id

  tags = {
    Name = "ExampleSnapshot"
  }
}

# 스냅샷 공유 권한 설정 - 스냅샷 있는 경우 항상 같이 있어야 함
resource "aws_snapshot_create_volume_permission" "example_permission" {
  snapshot_id = aws_ebs_snapshot.example_snapshot.id
  account_id  = "123456789012" # 공유할 AWS 계정 ID
}