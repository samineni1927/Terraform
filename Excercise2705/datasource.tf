data "aws_subnets" "dbsubnets" {
  filter {
      name      = "tag:Name"
      values    = var.db_subnets 
    }
  filter {
    name        = "vpc-id"
    values      = [aws_vpc.ssvpc.id]
  }
}