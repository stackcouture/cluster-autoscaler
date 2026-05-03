output "public_subnets" {
  value = [for subnet in aws_subnet.public-subnet : subnet.id]
}

output "private_subnets" {
  value = [for subnet in aws_subnet.private-subnet : subnet.id]
}