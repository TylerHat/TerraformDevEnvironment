resource "aws_vpc" "dev_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Dev"
  }
}

resource "aws_subnet" "dev_public_subnet" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"

  tags = {
    Name = "Dev-public"
  }
}

resource "aws_internet_gateway" "dev_internet_gateway" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    "Name" = "Dev-igw"
  }
}

resource "aws_route_table" "dev-public-rt" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    "Name" = "Dev-Public Route Table"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.dev-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev_internet_gateway.id
}

resource "aws_route_table_association" "dev_public_association" {
  subnet_id      = aws_subnet.dev_public_subnet.id
  route_table_id = aws_route_table.dev-public-rt.id

}

resource "aws_security_group" "dev_sg" {
  name        = "dev_sg"
  description = "Dev Environment security group"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #Update this ip to what your current IP is set at
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_key_pair" "dev_auth" {
  key_name   = "Dev_Env_Key"
  #public_key = file("C:/Users/Tyler Hatfield/.ssh/Dev_Env_Key.pub") #This is where the key pair is located
  public_key = file("${var.ssh_tyler_path}/Dev_Env_Key.pub")
  
}

resource "aws_instance" "dev_node" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.dev_auth.id
  vpc_security_group_ids = [aws_security_group.dev_sg.id]
  subnet_id              = aws_subnet.dev_public_subnet.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10 #dont increase this because it may no longer be in the free tier
  }

  tags = {
    Name = "Dev-Node"
  }

  provisioner "local-exec" {
    command = templatefile("${var.host_os_ssh}-ssh-config.tpl", {
      hostname     = self.public_ip,
      user         = "${var.username}",
      #identityfile = "C:/Users/Tyler Hatfield/.ssh/Dev_Env_Key"
      identityfile = "${var.ssh_tyler_path}/Dev_Env_Key"
    })
    interpreter = var.host_os_ssh == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  }


}
