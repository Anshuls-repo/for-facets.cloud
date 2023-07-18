
# Create a VPC
resource "aws_vpc" "forassignment_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "forassignment-vpc"
  }
}

# Create two subnets in the VPC
resource "aws_subnet" "forassignment_subnet_1" {
  vpc_id     = aws_vpc.forassignment_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "forassignment-subnet-1"
  }
}

resource "aws_subnet" "forassignment_subnet_2" {
  vpc_id     = aws_vpc.forassignment_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "forassignment-subnet-2"
  }
}

# Create a security group for the instances
resource "aws_security_group" "forassignment_sg" {
  name_prefix = "forassignment-sg"
  vpc_id      = aws_vpc.forassignment_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "forassignment-sg"
  }
}

# Create an internet gateway for the VPC
resource "aws_internet_gateway" "forassignment_igw" {
  vpc_id = aws_vpc.forassignment_vpc.id

  tags = {
    Name = "forassignment-igw"
  }
}

# Create a network interface for each instance
resource "aws_network_interface" "forassignment_1" {
  subnet_id       = aws_subnet.forassignment_subnet_1.id
  security_groups = [aws_security_group.forassignment_sg.id]

  tags = {
    Name = "forassignment-nic-1"
  }
}

resource "aws_network_interface" "forassignment_2" {
  subnet_id       = aws_subnet.forassignment_subnet_2.id
  security_groups = [aws_security_group.forassignment_sg.id]

  tags = {
    Name = "forassignment-nic-2"
  }
}

# Create a route table for the subnet
resource "aws_route_table" "forassignment_route_table-1" {
  vpc_id = aws_vpc.forassignment_vpc.id

  tags = {
    Name = "forassignment-route-table"
  }
}

# Add a route to the internet gateway in the route table
resource "aws_route" "forassignment_route-1" {
  route_table_id            = aws_route_table.forassignment_route_table-1.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.forassignment_igw.id
  depends_on                = [aws_internet_gateway.forassignment_igw]
}

# Associate the subnet with the route table
resource "aws_route_table_association" "forassignment_subnet_association-1" {
  subnet_id      = aws_subnet.forassignment_subnet_1.id
  route_table_id = aws_route_table.forassignment_route_table-1.id
}

# Create a route table for the subnet2
resource "aws_route_table" "forassignment_route_table-2" {
  vpc_id = aws_vpc.forassignment_vpc.id

  tags = {
    Name = "forassignment-route-table"
  }
}

# Add a route to the internet gateway in the route table
resource "aws_route" "forassignment_route-2" {
  route_table_id            = aws_route_table.forassignment_route_table-2.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.forassignment_igw.id
  depends_on                = [aws_internet_gateway.forassignment_igw]
}

# Associate the subnet with the route table
resource "aws_route_table_association" "forassignment_subnet_association-2" {
  subnet_id      = aws_subnet.forassignment_subnet_2.id
  route_table_id = aws_route_table.forassignment_route_table-2.id
}
