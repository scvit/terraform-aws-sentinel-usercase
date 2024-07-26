# VPC 생성
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

# 퍼블릭 서브넷 생성
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 1)
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# 프라이빗 서브넷 생성
resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 2)
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet"
  }
}

# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# 퍼블릭 라우트 테이블 생성
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# 퍼블릭 서브넷에 라우트 테이블 연결
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# EC2 인스턴스 생성 (프라이빗 서브넷)
resource "aws_instance" "private_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private.id

  tags = {
    Name = "private-instance"
  }
}

# Elastic IP 생성 - 위반사항
resource "aws_eip" "private_instance_eip" {
  domain   = "vpc"
  instance = aws_instance.private_instance.id
}

# 두 번째 네트워크 인터페이스 생성 (퍼블릭 서브넷)
resource "aws_network_interface" "public_eni" {
  subnet_id   = aws_subnet.public.id
  private_ips = [cidrhost(aws_subnet.public.cidr_block, 100)]

  attachment {
    instance     = aws_instance.private_instance.id
    device_index = 1
  }
}