resource "aws_vpc" "ssvpc" {
    cidr_block              = var.network_cidr
    tags                    = {
      "Name"                = "vpc-ss"
    }
  
}

resource "aws_internet_gateway" "samgw" {
    vpc_id                  = aws_vpc.ssvpc.id
    tags                    = {
        Name                = "sam-gw"
    }
  depends_on = [
    aws_vpc.ssvpc,
    aws_subnet.subnets
  ]
}

resource "aws_subnet" "subnets" {
  count                 = length(var.tags_name)
  cidr_block            = cidrsubnet(var.network_cidr,8,count.index)
  availability_zone     = format("${var.default_region}%s", count.index%2==0?"a":"b")
  tags                  = {
    "Name"              = var.tags_name[count.index]
  }
  vpc_id                = aws_vpc.ssvpc.id

  depends_on = [
    aws_vpc.ssvpc
  ]
}

# webserver-sg for accesing through internet

resource "aws_security_group" "websg" {
  name                  = "websg"
  description           = "web_security_group" 
  vpc_id                = aws_vpc.ssvpc.id
  
  ingress {
    cidr_blocks         = [local.any_where]
    from_port           = local.ssh_port
    to_port             = local.ssh_port
    protocol            = local.tcp
  }
  ingress {
    cidr_blocks         = [local.any_where]
    from_port           = local.http_port
    to_port             = local.http_port
    protocol            = local.tcp
  }

  egress  {
    cidr_blocks         = [ local.any_where ]
    from_port           = local.all_ports
    to_port             = local.all_ports
    protocol            = local.any_protocol
    ipv6_cidr_blocks    = [local.any_where_ip6]
  }
  tags                  = {
    Name                = "web_security"
  }
  depends_on = [
    aws_vpc.ssvpc
  ] 
      
}

# private secuirty group for accesing app server

resource "aws_security_group" "app" {
  name                  = "appdb-sg"
  description           = "sg for app" 
  vpc_id                = aws_vpc.ssvpc.id
  
  ingress {
    cidr_blocks         = [ local.any_where ]
    from_port           = local.ssh_port
    to_port             = local.ssh_port
    protocol            = local.tcp
  }
  ingress {
    cidr_blocks         = [ var.network_cidr ]
    from_port           = local.app_port
    to_port             = local.app_port
    protocol            = local.tcp
  }    

  egress  {
    cidr_blocks         = [local.any_where]
    from_port           = local.all_ports
    to_port             = local.all_ports
    protocol            = local.any_protocol
    ipv6_cidr_blocks    = [ local.any_where_ip6 ]
  }
  tags                  = {
    Name                = "app_security"
  }
  depends_on = [
    aws_vpc.ssvpc
  ] 
      
}

# private secuirty group for accesing db server

resource "aws_security_group" "db" {
  name                  = "db-sg"
  description           = "sg for db" 
  vpc_id                = aws_vpc.ssvpc.id
  
  ingress {
    cidr_blocks         = [ local.any_where ]
    from_port           = local.ssh_port
    to_port             = local.ssh_port
    protocol            = local.tcp
  }
  ingress {
    cidr_blocks         = [ var.network_cidr ]
    from_port           = local.db_port
    to_port             = local.db_port
    protocol            = local.tcp
  }    

  egress  {
    cidr_blocks         = [local.any_where]
    from_port           = local.all_ports
    to_port             = local.all_ports
    protocol            = local.any_protocol
    ipv6_cidr_blocks    = [ local.any_where_ip6 ]
  }
  tags                  = {
    Name                = "db_security"
  }
  depends_on = [
    aws_vpc.ssvpc
  ] 
      
}

resource "aws_route_table" "publicrt" {
    vpc_id              = aws_vpc.ssvpc.id

    route  {
        cidr_block      = local.any_where
        gateway_id      = aws_internet_gateway.samgw.id
    }
    tags                = {
        Name            = "Public RT"
    }
    depends_on = [
      aws_internet_gateway.samgw
    ]
  }

resource "aws_route_table" "privatert" {
    vpc_id              = aws_vpc.ssvpc.id

    tags                = {
        Name            = "Prviate RT"
    }
    depends_on = [
      aws_internet_gateway.samgw
    ]        
}

resource "aws_route_table_association" "rtassociations" {
    count               = length(aws_subnet.subnets)
    subnet_id           = aws_subnet.subnets[count.index].id
    route_table_id      = contains(var.public_subnets,lookup(aws_subnet.subnets[count.index].tags_all, "Name", "")) ? aws_route_table.publicrt.id : aws_route_table.privatert.id 
  depends_on = [
    aws_route_table.publicrt,
    aws_route_table.privatert
  ]

}

resource "aws_db_instance" "rdsdatabase" {
  db_name               = "dbmysqlfirst"
  allocated_storage    = "20"  
  engine                = "mysql"
  engine_version        = "8.0.28"
  instance_class        = "db.t3.micro"
  username              = "admin"
  password              = "admin456"
  db_subnet_group_name  = "ssam-db-subnet-group"
  skip_final_snapshot   = true
  identifier            = "databaseforsql" 

  depends_on = [
    aws_db_subnet_group.db_subnetgroup
  ]
}
