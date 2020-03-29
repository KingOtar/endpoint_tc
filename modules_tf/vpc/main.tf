resource "aws_vpc" "endpoint_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true

		tags = {
			Name = "${var.project_name}-vpc"
		}
}

resource "aws_internet_gateway" "endpoint_ig" {
    vpc_id = aws_vpc.endpoint_vpc.id
}

resource "aws_subnet" "endpoint_vpc_public_subnet" {
    vpc_id = aws_vpc.endpoint_vpc.id

    cidr_block = var.public_subnet_cidr
		availability_zone = "us-east-1a"
		map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-public-subnet"
    }
}

resource "aws_route_table" "endpoint_vpc_public_subnet_rt" {
    vpc_id = aws_vpc.endpoint_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.endpoint_ig.id
    }

    tags = {
        Name = "Public Subnet"
    }
}

resource "aws_route_table_association" "endpoint_vpc_public_subnet_assoc" {
    subnet_id = aws_subnet.endpoint_vpc_public_subnet.id
    route_table_id = aws_route_table.endpoint_vpc_public_subnet_rt.id
}


