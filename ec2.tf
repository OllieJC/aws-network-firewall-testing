resource "aws_instance" "test_host" {
  ami                    = data.aws_ami.amazon-linux-2.id
  subnet_id              = aws_subnet.ec2-a.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.host_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-test-host-${var.test_case}"
    },
  )
}

resource "aws_iam_role" "instance_role" {
  name               = "session-manager-instance-profile-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "ec2.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }
}
EOF

  tags = merge(
    var.additional_tags,
    {
      Name = "anfw-instance-role-${var.test_case}"
    },
  )
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "session-manager-instance-profile"
  role = aws_iam_role.instance_role.name
}

resource "aws_iam_role_policy_attachment" "instance_role_policy_attachment" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
