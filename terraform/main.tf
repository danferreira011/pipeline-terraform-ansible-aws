terraform {
  required_providers {
    aws = {      
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

resource "aws_instance" "web_server" {
  ami                    = var.ec2_ami
  instance_type          = "t3.micro"
  associate_public_ip_address = true
  key_name               = var.ssh_key_name
  subnet_id              = aws_subnet.public_subnet_az1.id
  vpc_security_group_ids = [aws_security_group.sg_terraform.id]

  tags = {
    Name = var.ec2_name
  }
}

resource "aws_security_group" "sg_terraform" {
  name        = "sg_terraform"
  description = "Allow SSH, HTTP and HTTPS"
  vpc_id      = aws_vpc.minha_vpc_tf.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_terraform"
  }
}
# VPC
resource "aws_vpc" "minha_vpc_tf" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "minha_vpc_tf"
  }
}

# Internet Gateway 
resource "aws_internet_gateway" "igw_tf" {
  vpc_id = aws_vpc.minha_vpc_tf.id
  tags = {
    Name = "main-igw"
  }
}

# Route
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_tf.id  
}

# Route Table Association
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.minha_vpc_tf.id
  tags = {
  Name = "public-rt"
}
}

# Route Table Association Public Subnet 1a
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_rt.id  
}

# Route Table Association Public Subnet 1c
resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_rt.id
}

# criação do elastic IP para o NAT Gateway
resource "aws_eip" "nat_eip_1" {
  domain = "vpc"
  tags = {
    Name = "nat-eip"
  }
}

# Criação do NAT Gateway
resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public_subnet_az1.id
  depends_on = [aws_internet_gateway.igw_tf]
  tags = {
  Name = "nat-gateway"
}
}

# Route Table privada 1a
resource "aws_route_table" "private_rt_1a" {
  vpc_id = aws_vpc.minha_vpc_tf.id
  tags = {
  Name = "private-rt-1a"
}
}

# Route Table privada 1c
resource "aws_route_table" "private_rt_1c" {
  vpc_id = aws_vpc.minha_vpc_tf.id
  tags = {
  Name = "private-rt-1c"
}
}

# Route for Private Subnets to use NAT Gateway
resource "aws_route" "private_nat_1" {
  route_table_id         = aws_route_table.private_rt_1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1.id

 
}

resource "aws_route" "private_nat_2" {
  route_table_id         = aws_route_table.private_rt_1c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_1.id
}

# Route Table Association for Private Subnets 
resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_az1.id
  route_table_id = aws_route_table.private_rt_1a.id
}

# Route Table Association for Private Subnets
resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.private_rt_1c.id
}

# Availability Zones
data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.minha_vpc_tf.id
  cidr_block              = "10.0.1.0/24"

  availability_zone       = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = true

  tags = {
    Name = "public-az1"
  }
}
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.minha_vpc_tf.id
  cidr_block              = "10.0.3.0/24"

  availability_zone       = data.aws_availability_zones.available.names[1]

  map_public_ip_on_launch = true

  tags = {
    Name = "public-az2"
  }
}
resource "aws_subnet" "private_subnet_az1" {
  vpc_id     = aws_vpc.minha_vpc_tf.id
  cidr_block = "10.0.11.0/24"

  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "private-az1"
  }
}
resource "aws_subnet" "private_subnet_az2" {
  vpc_id     = aws_vpc.minha_vpc_tf.id
  cidr_block = "10.0.12.0/24"

  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "private-az2"
  }
}