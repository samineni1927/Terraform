# create two webserver on ubuntu

resource "aws_instance" "webserver" {
    count                   = var.webserver.count 
    ami                     = var.webserver.ami_id
    instance_type           = var.webserver.instance_type
    associate_public_ip_address = var.webserver.public_ip_enabled
    vpc_security_group_ids  = [aws_security_group.app.id]
    subnet_id               = data.aws_subnets.appsubnets.ids[count.index]
    key_name                = aws_key_pair.terraformkey.key_name
    tags                    = {
        Name                = format("%s-%d",var.webserver.name, count.index+1)
    }                    
}