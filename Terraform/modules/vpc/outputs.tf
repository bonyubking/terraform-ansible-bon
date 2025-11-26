output "public_subnets" {
  value = {
    for k, v in aws_subnet.subnets : k => v.id if var.subnets[k].public
  }
}

output "private_subnets" {
  value = {
    for k, v in aws_subnet.subnets : k => v.id if var.subnets[k].public == false
  }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "route_table_id" {
  value = aws_route_table.bon-terra-private.id
}