resource "aws_security_group" "mail_instance_sg" {
  name        = "mail-instance-sg"
  vpc_id      = data.aws_ssm_parameter.vpc_id_parameter.value
  provider = aws.ses_aws
  
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  tags = {
    Name = "mail-instance-sg"
  }
}

resource "aws_instance" "mail_instance" {
  ami           = "ami-0ca285d4c2cda3300" 
  instance_type = "t2.micro"
  subnet_id = data.aws_ssm_parameter.subnet_web_C_id.value
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.mail_instance_sg.id]
  provider = aws.ses_aws
  
  tags = {
    Name = "mail-instance"
  }
}