# VPC
resource "aws_vpc" "quorum-vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "${var.environment}-${var.project}-vpc"
    Project = "${var.project}"
    Environment = "${var.environment}"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "quorum-gw" {
  vpc_id = "${aws_vpc.quorum-vpc.id}"

  tags {
    Name = "${var.environment}-${var.project}-gw"
    Project = "${var.project}"
    Environment = "${var.environment}"
  }
}

# Define the route table
resource "aws_route_table" "quorum-rt" {
  vpc_id = "${aws_vpc.quorum-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.quorum-gw.id}"
  }

  tags {
    Name = "${var.environment}-${var.project}-rt"
    Project = "${var.project}"
    Environment = "${var.environment}"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "quorum-rt-s" {
  subnet_id = "${aws_subnet.quorum-public-subnet-a.id}"
  route_table_id = "${aws_route_table.quorum-rt.id}"
}

# Public subnet
resource "aws_subnet" "quorum-public-subnet-a" {
  vpc_id = "${aws_vpc.quorum-vpc.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "${var.aws_region}a"

  tags {
    Name = "${var.environment}-${var.project}-public-a"
    Project = "${var.project}"
    Environment = "${var.environment}"
    SubnetType = "public"
  }
}
