resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16" #IPv4 CIDR Block
    enable_dns_hostnames = true #DNS Hostname 사용 옵션, 기본은 false
    tags =  { Name = "vpc"} #tag 입력
}

# 인터넷 게이트웨이
resource "aws_internet_gateway" "terra-igw" {
    vpc_id = aws_vpc.vpc.id #어느 VPC와 연결할 것인지 지정
    tags = { Name = "terraform-bon-igw"}  #태그 설정
}


# Subnet Public
resource "aws_subnet" "bon-terraform-subnet-public1" {
    vpc_id = aws_vpc.vpc.id #위에서 생성한 vpc 별칭 입력
    cidr_block = "10.0.10.0/24" #IPv4 CIDER 블럭
    availability_zone = "ap-northeast-2a" #가용영역 지정
    map_public_ip_on_launch = true #퍼블릭 IP 자동 부여 설정
    tags = { Name = "terra-sub-public1"} #태그 설정

}


# Subnet Public2
resource "aws_subnet" "bon-terraform-subnet-public2" {
    vpc_id = aws_vpc.vpc.id #위에서 생성한 vpc 별칭 입력
    cidr_block = "10.0.20.0/24" #IPv4 CIDER 블럭
    availability_zone = "ap-northeast-2b" #가용영역 지정
    map_public_ip_on_launch = true #퍼블릭 IP 자동 부여 설정
    tags = { Name = "terra-sub-public2"} #태그 설정

}


# Subnet Private
resource "aws_subnet" "bon-terraform-subnet-private1" {
    vpc_id = aws_vpc.vpc.id #위에서 생성한 vpc 별칭 입력
    cidr_block = "10.0.30.0/24" #IPv4 CIDER 블럭
    availability_zone = "ap-northeast-2a" #가용영역 지정
    map_public_ip_on_launch = false #퍼블릭 IP 자동 부여 설정
    tags = { Name = "terra-sub-private1"} #태그 설정

}


# Subnet Private2
resource "aws_subnet" "bon-terraform-subnet-private2" {
    vpc_id = aws_vpc.vpc.id #위에서 생성한 vpc 별칭 입력
    cidr_block = "10.0.40.0/24" #IPv4 CIDER 블럭
    availability_zone = "ap-northeast-2b" #가용영역 지정
    map_public_ip_on_launch = false #퍼블릭 IP 자동 부여 설정
    tags = { Name = "terra-sub-private2"} #태그 설정

}

# Public Routing Table
resource "aws_route_table" "bon-terra-public1" {
  vpc_id = aws_vpc.vpc.id #VPC 별칭 입력
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-igw.id #Internet Gateway 별칭 입력
  }
  tags = { Name = "terra-public1" } #태그 설정
}

# Private Routing Table
resource "aws_route_table" "bon-terra-private1" {
  vpc_id = aws_vpc.vpc.id #VPC 별칭 입력
  tags = { Name = "terra-private1" } #태그 설정
}

resource "aws_route_table_association" "public_association" {
  for_each = {
    "pub1" = aws_subnet.bon-terraform-subnet-public1.id
    "pub2" = aws_subnet.bon-terraform-subnet-public2.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.bon-terra-public1.id
}

resource "aws_route_table_association" "private_association" {
  for_each = {
    "pri1" = aws_subnet.bon-terraform-subnet-private1.id
    "pri2" = aws_subnet.bon-terraform-subnet-private2.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.bon-terra-private1.id
}


