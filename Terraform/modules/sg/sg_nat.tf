resource "aws_security_group" "myce_sg_nat" {
    name = "${var.sc_name_prefix}-sg-nat"
    vpc_id = var.vpc_id       
}


resource "aws_security_group_rule" "nat_security_1" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.myce_sg_nat.id
}

resource "aws_security_group_rule" "nat_security_3" {
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    cidr_blocks = ["10.0.0.0/16"]
    security_group_id = aws_security_group.myce_sg_nat.id
}

resource "aws_security_group_rule" "nat_security_2" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.myce_sg_nat.id
}