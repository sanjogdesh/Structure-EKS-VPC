variable "instance_type" {
    type = string
    default = "t2.micro"
  
}

variable "image-id" {
    type = string
    default = "ami-02b8269d5e85954ef"
    description = "my-saved-ami"
}

variable "key_name" {
    type = string
    default = "mumkey"
  
}

variable "security_group" {
    type = string
    default = "sg-07c1eec99b4d453cd"
  
}