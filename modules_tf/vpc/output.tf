output "vpc_id" {
	value = aws_vpc.endpoint_vpc.id
}

output "public_subnet_id" {
	value = aws_subnet.endpoint_vpc_public_subnet.id
}
