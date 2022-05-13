resource "aws_iam_policy" "ses_Fullaccess" {
  name        = "ses_Fullaccess"
  path        = "/"
  description = "Full access for SES"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ses:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "ses_role" {
  name = "ses_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            Effect = "Allow",
            Principal = {
                Service = "ec2.amazonaws.com"
            },
            Action = "sts:AssumeRole"
        }
    ]
  })
}

resource "aws_iam_policy_attachment" "ec2_policy_role" {
  name       = "ec2-policy-role"
  roles      = [aws_iam_role.ses_role.name]
  policy_arn = aws_iam_policy.ses_Fullaccess.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ses_role.name
}