resource "aws_internet_gateway" "ngw_a_ig" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-igw-${var.test_case}"
    },
  )
}

resource "aws_eip" "eip-ng" {
  vpc = true

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-ng-eip-${var.test_case}"
    },
  )
}

resource "aws_nat_gateway" "ng-a" {
  allocation_id = aws_eip.eip-ng.id
  subnet_id     = aws_subnet.ngw-a.id

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-natgw-${var.test_case}"
    },
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.ngw_a_ig]
}
