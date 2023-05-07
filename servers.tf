resource "aws_instance" "frontend" {
  ami           = "ami-0b5a2b5b8f2be4ec2"
  instance_type = "t3.micro"
  vpc_id      = [data.aws_security_group.allow-all]

  tags = {
    Name = "frontend"
  }
}

data "aws_security_group" "allow-all" {
  id = "allow-all"
  }


resource "aws_route53_record" "records" {
  zone_id = "Z08045122E2EQN1OR1WS6"
  name    = "frontend-dev.pavan345.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.frontend.private_ip]
}