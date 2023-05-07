resource "aws_instance" "instance" {
  ami = data.aws_ami.centos.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = var.env != "" ? "${var.components_name} -${var.env}" : var.components_name
  }
}

resource "null_resource" "provisioner" {
  depends_on = [aws_instance.instance,aws_route53_record.records]
  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     =aws_instance.instance.private_ip
    }
    inline = [
      "rm -rf Roboshop2",
      "git clone https://github.com/Pavanyandrapati/Roboshop2",
      "cd Roboshop2",
      "sudo bash ${var.components_name}.sh ${var.password}"
    ]
  }
}


resource "aws_route53_record" "records" {
  zone_id = "Z08045122E2EQN1OR1WS6"
  name    = "${var.components_name}-dev.pavan345.online"
  type    = "A"
  ttl     = 30
  records = [aws_instance.instance.private_ip]
}

