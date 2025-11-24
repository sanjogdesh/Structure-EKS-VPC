provider "aws" {
  region = "ap-south-1"  
}

resource "aws_instance" "main" {
  ami = var.image-id
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = "subnet-0d32a965141517d55"
  vpc_security_group_ids = [var.security_group]

  tags = {
    Name = "my-terra"
  }
}