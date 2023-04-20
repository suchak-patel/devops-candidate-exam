################################################################################
# Private Subnet
################################################################################

resource "aws_subnet" "private" {
    count               = length(var.vpc_private_subnets)
    cidr_block          = var.vpc_private_subnets[count.index]
    vpc_id              = data.aws_vpc.vpc.id
    tags = {
      Name = format("${var.name}-private-subnet-%s", count.index)
    }
    lifecycle {
        ignore_changes = [tags]
    }
}

resource "aws_route_table" "private" {
    vpc_id = data.aws_vpc.vpc.id

    tags = {
      Name = "${var.name}-private-rt"
    }
}

resource "aws_route_table_association" "private" {
    count = length(var.vpc_private_subnets)

    subnet_id = element(aws_subnet.private[*].id, count.index)
    route_table_id = aws_route_table.private.id
}

# Add RT rule for NAT
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = data.aws_nat_gateway.nat.id

  timeouts {
    create = "5m"
  }
}

resource "aws_security_group" "lambda" {
  name        = "${var.name}-lambda-sg"
  description = "Allow all outbound traffic"
  vpc_id      = data.aws_vpc.vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
