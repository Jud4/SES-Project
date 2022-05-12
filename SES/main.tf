resource "aws_ses_email_identity" "origin_mail_address" {
  email = "${var.sender_mail}"
  provider = aws.ses_aws
}

resource "aws_ses_email_identity" "receiving_mail_address" {
  email = "${var.Secondmail}"
  provider = aws.ses_aws
}