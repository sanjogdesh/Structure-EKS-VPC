#1_vpc_block
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_network_address_usage_metrics = true
    tags = {
        Name = "eks_vpc"
    }
  
}

#internet_gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "eks-igw"
    }
}

#subnet_block_
#subnet_public_1
resource "aws_subnet" "public_subnet_1"{
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "${var.region}a" #$->this means that we are using the avaialability zone 1
    map_public_ip_on_launch = true
    tags = {
      Name = "pub_sub_1"
    }
}

#subnet_public_2
resource "aws_subnet" "public_subnet_2"{
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "${var.region}b" #$->this means that we are using the availabilty zone 2
    map_public_ip_on_launch = true

    tags = {
        Name = "pub_sub_2"
    }
}

#subnet_private_1
resource "aws_subnet" "private_subnet_1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "${var.region}a"

    tags = {
        Name = "private_subnet_1"
    }
  
}

#subnet_private_2
resource "aws_subnet" "private_subnet_2"{
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "${var.region}b"

    tags = {
        Name = "private_subnet_2"
    }
}

#nat_gateway_block
resource "aws_eip" "nat_eip"{
    domain = "vpc"
    }

#nat_gateway_creation
resource "aws_nat_gateway" "nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_subnet_1.id
  
}

#route_table_public
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "public_rt_made_by_us"
    }
}

#route_table_private
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gw.id
    }
    tags = {
        Name = "private-rt"
    }
}

#route_table_associations_(private_association_1)
resource "aws_route_table_association" "private_assoc_1" {
    subnet_id = aws_subnet.private_subnet_1.id
    route_table_id = aws_route_table.private_rt.id
}

#route_table_associations_(private_association_2)
resource "aws_route_table_association" "private_assoc_2" {
    subnet_id = aws_subnet.private_subnet_2.id
    route_table_id = aws_route_table.private_rt.id  
}

#route_table_associations_(public_association_1)
resource "aws_route_table_association" "public_assoc_1"{
    subnet_id = aws_subnet.public_subnet_1.id
    route_table_id = aws_route_table.public_rt.id
}

#route_table_associations_(public_association_2)
resource "aws_route_table_association" "public_assoc_2"{
    subnet_id = aws_subnet.public_subnet_2.id
    route_table_id = aws_route_table.public_rt.id
}