resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.10.0/24"
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

 resource "aws_route_table_association" "public_route_table_association" {
   subnet_id = aws_subnet.public_subnet.id
   route_table_id = aws_route_table.public_route_table.id
 }

 resource "aws_route_table_association" "private_route_table_association" {
   subnet_id = aws_subnet.private_subnet.id
   route_table_id = aws_route_table.private_route_table.id
 }

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id = aws_subnet.public_subnet.id
  allocation_id = aws_eip.nat_gateway_eip.id
  depends_on = [ aws_internet_gateway.internet_gateway ]
}

resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc"
}