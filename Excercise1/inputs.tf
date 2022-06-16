# Providing varibales for the networks

variable "default_region" {
    type            = string
    default         = "ap-southeast-1"
    description     = "default region of aws"
  
}

variable "network_cidr" {
    type            = string
    default         = "10.0.0.0/16"

}

variable "tags_name" {
    type = list(string)
    default = [ "web1", "web2", "app1", "app2", "db1", "db2" ]
  
}

variable "s3_bucket" {
    type            = string
    default         = "ss-s3-bucket-456"
  
}