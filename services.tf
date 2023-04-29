variable "components" {
  default = ["frontend","mongodb","catalogue","user","cart","redis"]
}

resource "aws_instance" "components" {
  ami           = "ami-0b5a2b5b8f2be4ec2"
  instance_type = "t3.micro"
  count = length(var.components)
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]
  tags = {
    Name = var.components[count.index]
  }
}

data "aws_security_group" "allow-all" {
  name = "allow-all"
}

variable "records" {
  default = ["frontend-dev.pavan345.online","mongodb-dev.pavan345.online","catalogue-dev.pavan345.online","user-dev.pavan345.online","cart-dev.pavan345.online","redis-dev.pavan345.online"]
}

  resource "aws_route53_record" "dns_records" {
    count   = length(var.records)
    zone_id = "Z08045122E2EQN1OR1WS6"
    name    = var.records[count.index]
    type    = "A"
    ttl     = 30
    records = [aws_instance.instance[count.index].private_ip]
  }