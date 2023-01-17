resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = {
    Name = "Dev"
  }
}

resource "aws_subnet" "dev_public_subnet" {
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-2a"

  tags = {
    Name = "dev-public"
  }
}