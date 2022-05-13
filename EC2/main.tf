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
  # iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  provider = aws.ses_aws
  
  tags = {
    Name = "mail-instance"
  }
  
  user_data = <<EOF
#! /bin/bash
yum update -y
sudo yum -y install sendmail-cf m4 cyrus-sasl-plain
sudo echo "AuthInfo:email-smtp.us-west-2.amazonaws.com \"U:root\" \"I:${var.smpt_user}\" \"P:${var.smtp_password}\" \"M:PLAIN\"" > /etc/mail/authinfo
sudo sh -c 'makemap hash /etc/mail/authinfo.db < /etc/mail/authinfo'
sudo sh -c 'echo "Connect:email-smtp.us-west-2.amazonaws.com RELAY" >> /etc/mail/access'
sudo sh -c 'makemap hash /etc/mail/access.db < /etc/mail/access'
sudo sh -c 'cp /etc/mail/sendmail.cf /etc/mail/sendmail_cf.backup && cp /etc/mail/sendmail.mc /etc/mail/sendmail_mc.backup'
sudo sed -i "0,/^MAILER.*/s/^MAILER.*/define(\`SMART_HOST', \`email-smtp.us-west-2.amazonaws.com')dnl\n&/" /etc/mail/sendmail.mc
sudo sed -i "0,/^MAILER.*/s/^MAILER.*/define(\`RELAY_MAILER_ARGS', \`TCP \$h 25')dnl\n&/" /etc/mail/sendmail.mc
sudo sed -i "0,/^MAILER.*/s/^MAILER.*/define(\`confAUTH_MECHANISMS', \`LOGIN PLAIN')dnl\n&/" /etc/mail/sendmail.mc
sudo sed -i "0,/^MAILER.*/s/^MAILER.*/FEATURE(\`authinfo', \`hash -o \/etc\/mail\/authinfo.db')dnl\n&/" /etc/mail/sendmail.mc
sudo sed -i "0,/^MAILER.*/s/^MAILER.*/MASQUERADE_AS(\`${var.origin_domain}')dnl\n&/" /etc/mail/sendmail.mc
sudo sed -i "0,/^MAILER.*/s/^MAILER.*/FEATURE(masquerade_envelope)dnl\n&/" /etc/mail/sendmail.mc
sudo sed -i "0,/^MAILER.*/s/^MAILER.*/FEATURE(masquerade_entire_domain)dnl\n&/" /etc/mail/sendmail.mc
sudo chmod 666 /etc/mail/sendmail.cf
sudo sh -c 'm4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf'
sudo chmod 644 /etc/mail/sendmail.cf
sudo service sendmail restart
EOF
  
}