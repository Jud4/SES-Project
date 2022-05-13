# module "iam_cred" { # OUT: user and pass
#   source = "../IAM_credentials"
# }

module "ses" {
  source = "../SES"
  sender_mail = "${var.sender_mail}"
  Secondmail = "${var.Secondmail}"
}

module "ec2" {
  source = "../EC2"
  sender_mail = "${var.sender_mail}"
  Secondmail = "${var.Secondmail}"
  origin_domain = "${var.origin_domain}"
#   smpt_user = "${module.iam_cred.smtp_username}"
#   smtp_password = "${module.iam_cred.smtp_password}"
}