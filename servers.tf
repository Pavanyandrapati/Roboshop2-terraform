resource "aws_instance" "instance" {
  for_each = var.components
  ami           = "data.aws_ami.centos.image_id"
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]
  instance_type = each.value["instance_type"]

  tags = {
    Name = "each.value["name"]
  }
}


resource "aws_route53_record" "records" {
  for_each = var.components
  zone_id = "Z08045122E2EQN1OR1WS6"
  name    = "${each.value["name"]}-dev.pavan345.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance[each.value["name"]].private_ip]
}
