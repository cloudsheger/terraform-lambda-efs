data "aws_vpc" "this" {
  tags = {
    Name = var.name

  }
}

data "aws_subnet" "subnet_for_lambda" {
  vpc_id = data.aws_vpc.this.id
  subnet_ids = var.subnet_ids
}

data "aws_security_group" "sg_for_lambda" {
  vpc_id = data.aws_vpc.this.id
  security_group_ids = var.security_group
}