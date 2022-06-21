# Derfault region in aws provider
variable "default_region" {
    type            = string
    default         = "ap-south-1"
    description     = "default region"
}

# CIDR range
variable "network_cidr" {
    type            = string
    default         = "10.0.0.0/16"
}


# Subnet tags
variable "tags_name" {
    type            = list(string)
    default         = [ "web1","web2","app1","app2","db1","db2" ]
}

# public subnet
variable "public_subnets" {
    type            = list(string)
    default         = [ "web1", "web2" ] 
}

# DB subnet
variable "db_subnets" {
    type            = list(string)
    default         = [ "db1", "db2" ]
}


# app server info
variable "appserver" {
    type                    = object({
        count                   = number
        ami_id                  = string
        instance_type           = string
        subnets                 = list(string)
        name                    = string
        public_ip_enabled       = bool  
    })

    default                 = {
        count                   = 2
        ami_id                  = "ami-006d3995d3a6b963b"
        instance_type           = "t2.micro"
        subnets                 = ["app1","app2"]
        name                    = "appserver"
        public_ip_enabled       = false
    }
}


# web server info
variable "webserver" {
    type                    = object({
        count                   = number
        ami_id                  = string
        instance_type           = string
        subnets                 = list(string)
        name                    = string
        public_ip_enabled       = bool  
    })

    default                 = {
        count                   = 2
        ami_id                  = "ami-006d3995d3a6b963b"
        instance_type           = "t2.micro"
        subnets                 = ["web1","web2"]
        name                    = "webserver"
        public_ip_enabled       = true
    }
}