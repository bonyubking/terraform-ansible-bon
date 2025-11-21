resource "aws_instance" "servers" {
  for_each = var.instances

  ami                         = var.ami
  instance_type               = var.instance_type

  subnet_id                   = each.value.subnet
  key_name                    = var.key_name
  vpc_security_group_ids      = [each.value.sg]
  associate_public_ip_address = each.value.public

  tags = {
    Name = "${var.prefix}-${each.key}"
  }
}
