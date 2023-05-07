resource "aws_instance" "instance" {
  count = length(var.components)
  ami = "data.aws_ami.centos.image.id"
  instance_type = "t3.micro"
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = "var.components[count.index]"
  }
}
variable "components" {
  default = [frontend,mongodb,cart]
}

#resource "aws_route53_record" "frontend" {
#  zone_id = "Z08045122E2EQN1OR1WS6"
#  name    = "${}-dev.pavan345.online"
#  type    = "A"
#  ttl     = 30
#  records = [aws_instance.instance[count.index].private_ip]
#}

data "aws_security_group" "allow-all" {
  name = "allow-all"
}

data "aws_ami" "centos" {
  most_recent = true
  name_regex  = "Centos-8-DevOps-Practice"
  owners      = ["973714476881"]
}

