data "aws_ssm_parameter" "subnet_web_C_id" { # data.aws_ssm_parameter.subnet_web_C_id.value
  name = "/upb_vpc/subnets/sn-web-C"
  provider = aws.ses_aws
}
data "aws_ssm_parameter" "vpc_id_parameter" { # data.aws_ssm_parameter.vpc_id_parameter.value
  name = "/vpc/id"
  provider = aws.ses_aws
}