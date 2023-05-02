resource "aws_instance" "instance" {
  for_each = var.components
  ami           = data.aws_ami.centos.image_id
  instance_type = each.value["instance_type"]
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]


  tags = {
    Name = each.value["name"]
  }
}

variable "components" {
  default={
    frontend={
      name = "frontend"
      instance_type="t3.micro"
    }
    mongodb={
      name = "mongodb"
      instance_type="t3.small"
    }
    catalogue={
      name ="catalogue"
      instance_type = "t3.small"
    }
    user={
      name ="user"
      instance_type = "t3.small"
    }
    cart={
      name ="cart"
      instance_type = "t3.small"
    }
    redis={
      name ="redis"
      instance_type = "t3.small"
    }
    mysql={
      name ="mysql"
      instance_type = "t3.small"
    }
    shipping={
      name ="shipping"
      instance_type = "t3.small"
    }
    rabbitmq={
      name ="rabbitmq"
      instance_type = "t3.micro"
    }
    payment={
      name ="payment"
      instance_type = "t3.micro"
    }

  }
}
data "aws_security_group" "allow-all" {
  name = "allow-all"
}


data "aws_ami" "centos" {
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = ["973714476881"]
}


resource "aws_route53_record" "records" {
  for_each = var.components
  zone_id = "Z08045122E2EQN1OR1WS6"
  name    = "${each.value["name"]}-dev.pavan345.online"
  type    = "A"
  ttl     = 300
  records = [aws_instance.instance[each.value["name"]].private_ip]
}