# Creating two ubuntu appserver in aws
resource "aws_key_pair" "terraformkey" {
    key_name                = "serverkeytf"
    public_key              = file("~/.ssh/id_rsa.pub")  
    depends_on              = [
      aws_db_instance.rdsdatabase
    ]  
}


resource "aws_instance" "appserver" {
    count                   = var.appserver.count 
    ami                     = var.appserver.ami_id
    instance_type           = var.appserver.instance_type
    associate_public_ip_address = var.appserver.public_ip_enabled
    vpc_security_group_ids  = [aws_security_group.app.id]
    subnet_id               = data.aws_subnets.appsubnets.ids[count.index]
    key_name                = aws_key_pair.terraformkey.key_name
    tags                    = {
        Name                = format("%s-%d",var.appserver.name, count.index+1)
    }                    
}