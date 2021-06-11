resource "aws_vpc" "main" {
  cidr_block           = "10.88.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-VPC-${var.test_case}"
    },
  )
}

resource "aws_subnet" "ngw-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.88.51.0/24"
  availability_zone = "eu-west-2a"

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-SubnetNGW-A-${var.test_case}"
    },
  )
}

resource "aws_subnet" "fw-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.88.11.0/24"
  availability_zone = "eu-west-2a"

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
  availability_zone = "eu-west-2a"

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-SubnetEC2-A-${var.test_case}"
    },
  )
}
