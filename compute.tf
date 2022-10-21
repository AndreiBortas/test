
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "public_instance" {
  ami                    = data.aws_ami.amazon-linux.id #us-west 2
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.public.id]
  subnet_id              = aws_subnet.subnet[0].id
  iam_instance_profile   = aws_iam_instance_profile.ec2-profile-s3.id
  tags = {
    Name = "my-machine-public"
  }
}

resource "aws_key_pair" "generated_key" {
  key_name   = "terraform_ec2_key"
  public_key = file("terraform_ec2_key.pub")

}
