data "aws_subnets" "dbsubnets" {
  filter {
      name      = "tag:Name"
      values    = var.db_subnets 
    }
  filter {
    name        = "vpc-id"
    values      = [aws_vpc.ssvpc.id]
  }

  depends_on    = [
    aws_subnet.subnets
  ]
}

# appserver aws subnets

data "aws_subnets" "appsubnets" {
  filter {
    name        = "tag:Name"
    values      = var.appserver.subnets 
  }
  filter {
    name        = "vpc-id"
    values      = [aws_vpc.ssvpc.id] 
  }

  depends_on = [
    aws_key_pair.terraformkey
  ]
}

# webserver aws subnets

data "aws_subnets" "websubnets" {
  filter {
    name        = "tag:Name"
    values      = var.webserver.subnets 
  }
  filter {
    name        = "vpc-id"
    values      = [aws_vpc.ssvpc.id] 
  }

  depends_on = [
    aws_key_pair.terraformkey
  ]
}
