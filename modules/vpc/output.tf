output "aws_vpc_id" {
  value = aws_vpc.vpc.id
}

output "aws_subnet_ids_private" {
  value = aws_subnet.subnet-private.*.id
}

output "aws_subnet_ids_public" {
  value = aws_subnet.subnet-public.*.id
}

output "default_tags" {
  value = var.default_tags
}

output "aws_route_table_private" {
  value = aws_route_table.private-route-table.*.id
}