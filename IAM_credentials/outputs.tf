output "smtp_username" {
  value = aws_iam_access_key.smtp_auth.id
}

output "smtp_password" {
  value = aws_iam_access_key.smtp_auth.ses_smtp_password_v4
  sensitive = true
}