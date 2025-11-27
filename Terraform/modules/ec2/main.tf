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

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../Ansible/inventory/hosts.ini"

  content = <<-EOT
[bastion]
${aws_instance.servers["bastion"].public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/mykey.pem

[public]
${aws_instance.servers["public"].public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/mykey.pem

[private]
${aws_instance.servers["private"].private_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/mykey.pem ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -i ~/.ssh/mykey.pem ec2-user@${aws_instance.servers["bastion"].public_ip}"'

[nat]
${aws_instance.servers["nat"].public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/mykey.pem
EOT
}

