resource "aws_instance" "this" {
  ami = var.ami
  subnet_id = var.subnet_id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = var.security_group_ids
  associate_public_ip_address = var.use_public_ip
  tags = {
    Name = var.name
  }
}