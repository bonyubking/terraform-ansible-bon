resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr #IPv4 CIDR Block
    enable_dns_hostnames = true #DNS Hostname 사용 옵션, 기본은 false
    tags = {
        Name = "${var.name_prefix}-vpc"
    }
}

# 인터넷 게이트웨이
resource "aws_internet_gateway" "terra-igw" {
    vpc_id = aws_vpc.vpc.id #어느 VPC와 연결할 것인지 지정
    tags = {
        Name = "${var.name_prefix}-igw"
    }  
}

resource "aws_subnet" "subnets" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.public

  tags = {
    Name = "${var.name_prefix}-${each.key}"
  }
}



# Public Routing Table
resource "aws_route_table" "bon-terra-public" {
  vpc_id = aws_vpc.vpc.id #VPC 별칭 입력
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-igw.id #Internet Gateway 별칭 입력
  }
  
  tags = { 
    Name = "${var.name_prefix}-public-rt" } #태그 설정
}

# Private Routing Table
resource "aws_route_table" "bon-terra-private" {
  vpc_id = aws_vpc.vpc.id


  tags = {
    Name = "${var.name_prefix}-private-rt"
  }
}

resource "aws_route_table_association" "public_association" {
  for_each = {
    "pub1" = aws_subnet.subnets["public1"].id
    "pub2" = aws_subnet.subnets["public2"].id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.bon-terra-public.id
}


resource "aws_route_table_association" "private_association" {
  for_each = {
    "pri1" = aws_subnet.subnets["private1"].id
    "pri2" = aws_subnet.subnets["private2"].id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.bon-terra-private.id
}


