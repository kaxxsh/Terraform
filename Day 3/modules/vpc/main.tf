# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    var.tags,
    {
      Name        = "${var.name}-vpc"
      Environment = var.environment
      Project     = var.project
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    {
      Name        = "${var.name}-igw"
      Environment = var.environment
      Project     = var.project
    }
  )
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = merge(
    var.tags,
    {
      Name        = "${var.name}-public-subnet-${count.index + 1}"
      Environment = var.environment
      Project     = var.project
    }
  )
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = 4
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index % 2)
  tags = merge(
    var.tags,
    {
      Name        = "${var.name}-private-subnet-${count.index + 1}"
      Environment = var.environment
      Project     = var.project
    }
  )
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    {
      Name        = "${var.name}-public-rt"
      Environment = var.environment
      Project     = var.project
    }
  )
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway (only in 1 AZ)
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = merge(
    var.tags,
    {
      Name        = "${var.name}-nat-eip"
      Environment = var.environment
      Project     = var.project
    }
  )
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id  # NAT Gateway in the first public subnet
  tags = merge(
    var.tags,
    {
      Name        = "${var.name}-nat-gateway"
      Environment = var.environment
      Project     = var.project
    }
  )
}

# Private Route Table and Route through NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    {
      Name        = "${var.name}-private-rt"
      Environment = var.environment
      Project     = var.project
    }
  )
}

resource "aws_route" "private_to_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private" {
  count          = 4
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}