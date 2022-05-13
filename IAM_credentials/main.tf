# Credentials
resource "aws_iam_user" "smtp_auth" {
  name = "smtp_auth"
}

resource "aws_iam_access_key" "smtp_auth" {
  user = aws_iam_user.smtp_auth.name
}

resource "aws_iam_policy" "ses_sender" {# From data content
  name        = "ses_sender"
  description = "Allows sending of e-mails via Simple Email Service"
  policy      = data.aws_iam_policy_document.ses_sender.json
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.smtp_auth.name
  policy_arn = aws_iam_policy.ses_sender.arn
}
