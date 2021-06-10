resource "aws_instance" "test_host" {
  ami                    = data.aws_ami.amazon-linux-2.id
  subnet_id              = aws_subnet.ec2-a.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.host_sg.id]

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-test-host-${var.test_case}"
    },
  )
}
