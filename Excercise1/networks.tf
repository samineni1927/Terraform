

resource "aws_vpc" "sami" {
    cidr_block          = var.network_cidr
    tags                = {
      "Name"            = "sami"
    }
  
}

resource "aws_internet_gateway" "sami_igw" {
  vpc_id = aws_vpc.sami.id
  tags = {
    Name = "sami"
  }
     
}

resource "aws_subnet" "subnets" {
  count = length(var.tags_name)
  cidr_block = cidrsubnet(var.network_cidr,4,count.index)
  availability_zone = format("${var.default_region}%s", count.index%2==0?"a":"b")
  tags = {
    "Name" = var.tags_name[count.index]
  }
  vpc_id = aws_vpc.sami.id
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket
  tags = {
    "Name" = "s3-bucket-samineni"
  }

}
