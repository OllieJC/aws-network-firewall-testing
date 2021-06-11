resource "aws_vpc_endpoint" "vpc_a_ssm_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.ec2-a.id]
  security_group_ids = [
    aws_security_group.endpoint_sg.id,
  ]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "vpc_a_ssm_messages_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.ec2-a.id]
  security_group_ids = [
    aws_security_group.endpoint_sg.id,
  ]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "vpc_a_ec2_messages_endpoint" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.ec2-a.id]
  security_group_ids = [
    aws_security_group.endpoint_sg.id,
  ]
  private_dns_enabled = true
}
