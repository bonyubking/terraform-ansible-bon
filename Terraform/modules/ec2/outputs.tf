output "private_ip" {
  value = {
    for name, instance in aws_instance.servers : name => instance.private_ip
  }
}

output "public_ips" {
  value = {
    for name, instance in aws_instance.servers : name => instance.public_ip
  }
}

output "nat_eni_id" {
  value = aws_instance.servers["nat"].primary_network_interface_id
}
