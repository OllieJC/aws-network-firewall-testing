resource "aws_security_group" "endpoint_sg" {
  name        = "anfw-SG-endpoints-${var.test_case}"
  description = "Allow TLS inbound traffic for SSM/EC2 endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-SG-endpoints-${var.test_case}"
    },
  )
}

resource "aws_security_group" "host_sg" {
  name        = "anfw-SG-EC2-${var.test_case}"

  description = "Allow all traffic from VPCs inbound and all outbound"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "anfw-SG-EC2-${var.test_case}"
  }
}
