provider "aws" {
   region = "ap-south-1"
}

#create vpc
resource "aws_vpc" "terra_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-terra-vpc"
    }
  
}

# create a subnet
resource "aws_subnet" "my_subnet" {
    vpc_id = aws_vpc.terra_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"

    tags = {
        Name = "my-terra-subnet"
    }
}

# create an internet gateway
resource "aws_internet_gateway" "igw" {
     vpc_id = aws_vpc.terra_vpc.id

     tags = {
        Name = "terra-igw"
     }
}

#create a route table
resource "aws_route_table" "terra-rt" {
   vpc_id = aws_vpc.terra_vpc.id

   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
   }

   tags = {
     Name = "terra-rt"
   }
}

# associate route table with subnet
resource "aws_route_table_association" "my-rta" {
   subnet_id = aws_subnet.my_subnet.id
   route_table_id = aws_route_table.terra-rt.id
}

# create a security group allowing SSH
resource "aws_security_group" "my_sg" {
    name = "allow_ssh"
    description = "allow ssh inbound traffic"
    vpc_id = aws_vpc.terra_vpc.id

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "my-terra-sg"
    }
  
}

# launch ec2 instance inside VPC/subnet
resource "aws_instance" "my-terra" {
    ami = "ami-02d26659fd82cf299"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.my_subnet.id
    vpc_security_group_ids = [ aws_security_group.my_sg.id ]
    key_name = "mumkey"

    tags = {
      Name = "ec2-terra"
    }
  
}

vpc creation by terraform