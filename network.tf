data "aws_availability_zones" "available" {}
#list of all azs available

resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.my-vpc.id
  tags = {
    Name = "Internet_Gateway"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.subnet[0].id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_eip" "nat1" {
  depends_on = [aws_internet_gateway.main]
}

resource "aws_subnet" "subnet" {
  count             = 3
  cidr_block        = cidrsubnet(aws_vpc.my-vpc.cidr_block, 8, count.index)
  vpc_id            = aws_vpc.my-vpc.id
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "${cidrsubnet(aws_vpc.my-vpc.cidr_block, 8, count.index)}-${data.aws_availability_zones.available.names[count.index]}"
  }
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.main.id
  }
  tags = {
    Name = "Public Route Table"
  }
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet[0].id
  route_table_id = aws_route_table.public.id
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.my-vpc.default_network_acl_id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
}
