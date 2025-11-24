provider "aws" {
    region = "ap-south-1"
  
}


module "ec2_call" {
    source = "./module/ec2"
  
}  
