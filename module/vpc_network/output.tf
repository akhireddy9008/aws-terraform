output "vpc_id" {
  value = aws_vpc.main_vpc.id
}
output "subnet_id_1" {
  value = aws_subnet.private_sub1.id
}
output "subnet_id_2" {
  value = aws_subnet.private_sub2.id
}
output "subnet_id_3" {
  value = aws_subnet.public_sub1.id
}
output "subnet_id_4" {
  value = aws_subnet.public_sub2.id
}
output "vpc_route_table" {
  value = aws_route_table.route_private.id
}