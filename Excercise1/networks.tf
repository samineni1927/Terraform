# Create vpc and subnets in aws

resource "aws_vpc" "sami" {
    cidr_block          = var.network_cidr
    tags                = {
      "Name"            = "sami"
    }
  
}

resource "aws_internet_gateway" "sami_igw" {
  vpc_id                = aws_vpc.sami.id
  tags                  = {
    Name                = "sami"
  }
     
}

resource "aws_subnet" "subnets" {
  count                 = length(var.tags_name)
  cidr_block            = cidrsubnet(var.network_cidr,4,count.index)
  availability_zone     = format("${var.default_region}%s", count.index%2==0?"a":"b")
  tags                  = {
    "Name"              = var.tags_name[count.index]
  }
  vpc_id                = aws_vpc.sami.id
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket                = var.s3_bucket
  tags                  = {
    "Name"              = "s3-bucket-samineni"
  }

}

resource "aws_security_group" "websecurity" {
  name                  = "allow_all"
  description           = "for terraform aws" 
  vpc_id                = aws_vpc.sami.id
  
  ingress {
    cidr_blocks         = [ "0.0.0.0/0" ]
    from_port           = 22
    to_port             = 22
    protocol            = "tcp"
  } 
  egress  {
    cidr_blocks         = [ "0.0.0.0/0" ]
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    ipv6_cidr_blocks    = ["::/0"]
  }
  tags                  = {
    Name                = "web_security"
  } 
      
}