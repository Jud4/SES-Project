locals {
  subnets = {
    "sn-reserved-A"= {
      cidr_block="10.16.0.0/20"
      az="us-west-2a"
    }
    "sn-db-A"= {
      cidr_block="10.16.16.0/20"
      az="us-west-2a"
    }
    "sn-app-A"= {
      cidr_block="10.16.32.0/20"
      az="us-west-2a"
    }
    "sn-web-A"= {
      cidr_block="10.16.48.0/20"
      az="us-west-2a"
    }
    "sn-reserved-B"= {
      cidr_block="10.16.64.0/20"
      az="us-west-2b"
    }
    "sn-db-B"= {
      cidr_block="10.16.80.0/20"
      az="us-west-2b"
    }
    "sn-app-B"= {
      cidr_block="10.16.96.0/20"
      az="us-west-2b"
    }
    "sn-web-B"= {
      cidr_block="10.16.112.0/20"
      az="us-west-2b"
    }
    "sn-reserved-C"= {
      cidr_block="10.16.128.0/20"
      az="us-west-2c"
    }
    "sn-db-C"= {
      cidr_block="10.16.144.0/20"
      az="us-west-2c"
    }
    "sn-app-C"= {
      cidr_block="10.16.160.0/20"
      az="us-west-2c"
    }
    "sn-web-C"= {
      cidr_block="10.16.176.0/20"
      az="us-west-2c"
    }
  }
}

resource "aws_vpc" "upb_vpc" {
  cidr_block = "10.16.0.0/16"
  assign_generated_ipv6_cidr_block=true
  enable_dns_hostnames=true
  provider = aws.ses_aws
  tags = {
      Name="upb_vpc"
  }
}
resource "aws_subnet" "subnets" {
  for_each   = local.subnets
  vpc_id     = aws_vpc.upb_vpc.id
  cidr_block = each.value.cidr_block
  availability_zone= each.value.az
  provider = aws.ses_aws
  
  tags = {
    Name = each.key
  }
}

resource "aws_internet_gateway" "upb_igw" {
  vpc_id = aws_vpc.upb_vpc.id
  provider = aws.ses_aws

  tags = {
    Name = "upb-igw"
  }
}

resource "aws_route_table" "upb_rt" {
  vpc_id = aws_vpc.upb_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.upb_igw.id
  }
  provider = aws.ses_aws

  tags = {
    Name = "upb-web-rt"
  }
}
resource "aws_route_table_association" "web_rt_association" {
  for_each = {
    "sn-web-A" = local.subnets.sn-web-A
    "sn-web-B" = local.subnets.sn-web-B
    "sn-web-C" = local.subnets.sn-web-C
  }
  subnet_id      = aws_subnet.subnets["${each.key}"].id
  route_table_id = aws_route_table.upb_rt.id
  provider = aws.ses_aws
}
