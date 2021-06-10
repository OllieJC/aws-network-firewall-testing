resource "aws_vpc" "main" {
  cidr_block       = "10.88.0.0/16"
  instance_tenancy = "default"

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-VPC-${var.test_case}"
    },
  )
}

resource "aws_subnet" "fw-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.88.11.0/24"
  availability_zone = "eu-west-2"

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-SubnetFW-A-${var.test_case}"
    },
  )
}

resource "aws_subnet" "ec2-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.88.31.0/24"
  availability_zone = "eu-west-2"

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-SubnetEC2-A-${var.test_case}"
    },
  )
}
