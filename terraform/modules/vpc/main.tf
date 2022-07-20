resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-IGW"
  }
}

resource "aws_route" "route-public" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${each.value.name}"
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${each.value.name}"
  }
}

resource "aws_eip" "gw" {
  for_each = var.nat_gateway
  vpc        = true
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.vpc_name}-EIP"
  }
}

resource "aws_nat_gateway" "gw" {
  for_each      = var.nat_gateway

  subnet_id     = aws_subnet.public[each.value.subnet_key].id
  allocation_id = aws_eip.gw[each.key].id
  # connectivity_type = "private"

  tags = {
    Name = "${var.vpc_name}-NAT-${each.value.subnet_key}"
  }
}

resource "aws_route_table" "private" {
  for_each = aws_nat_gateway.gw
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = each.value.id
  }

  tags = {
    Name = "${var.vpc_name}-rt-private"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_vpc.main.main_route_table_id
}

resource "aws_route_table_association" "private" {
  depends_on = [
    aws_route_table.private,
    aws_subnet.private
  ]
  for_each       = var.private_route_table_asociation

  subnet_id      = aws_subnet.private[each.value.subnet].id
  route_table_id = aws_route_table.private[each.value.nat].id
}
