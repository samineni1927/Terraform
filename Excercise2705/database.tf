# Creating db subnet group
resource "aws_db_subnet_group" "db_subnetgroup" {
    name            = "ssam-db-subnet-group"
    subnet_ids      = data.aws_subnets.dbsubnets.ids 
}