resource "aws_route_table" "natgw" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    vpc_endpoint_id = element([for ss in tolist(aws_networkfirewall_firewall.anfw.firewall_status[0].sync_states) : ss.attachment[0].endpoint_id], 0)
  }

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-natgw-rtb-${var.test_case}"
    },
  )
}

resource "aws_route_table_association" "ngw" {
  subnet_id      = aws_subnet.ngw-a.id
  route_table_id = aws_route_table.natgw.id
}


resource "aws_route_table" "firewall" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ngw_a_ig.id
  }

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-firewall-rtb-${var.test_case}"
    },
  )
}

resource "aws_route_table_association" "fw" {
  subnet_id      = aws_subnet.fw-a.id
  route_table_id = aws_route_table.firewall.id
}


resource "aws_route_table" "ec2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ng-a.id
  }

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-ec2-rtb-${var.test_case}"
    },
  )
}

resource "aws_route_table_association" "ec2" {
  subnet_id      = aws_subnet.ec2-a.id
  route_table_id = aws_route_table.ec2.id
}


resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route = []

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-default-rtb-${var.test_case}"
    },
  )
}


resource "aws_route_table" "no-subnet" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = aws_vpc.main.cidr_block
    vpc_endpoint_id = element([for ss in tolist(aws_networkfirewall_firewall.anfw.firewall_status[0].sync_states) : ss.attachment[0].endpoint_id], 0)
  }

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-no-subnets-rtb-${var.test_case}"
    },
  )
}
