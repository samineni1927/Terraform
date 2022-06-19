# Derfault region in aws provider
variable "default_region" {
    type            = string
    default         = "ap-southeast-1"
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
