resource "aws_ses_email_identity" "origin_mail_address" {
  email = "${var.sender_mail}"
}

resource "aws_ses_email_identity" "receiving_mail_address" {
  email = "${var.Secondmail}"
}