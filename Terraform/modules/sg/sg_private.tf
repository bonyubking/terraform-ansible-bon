

resource "aws_security_group" "myce_sg" {
    name = "${var.sc_name_prefix}-sg-private"
    vpc_id = var.vpc_id     
}

locals {
    bastion_id = aws_security_group.myce_sg_bastion.id
    public_id = aws_security_group.myce_sg_public.id
}

resource "aws_security_group_rule" "security_private" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    source_security_group_id = local.bastion_id
    security_group_id = aws_security_group.myce_sg.id
}

resource "aws_security_group_rule" "security_2" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    source_security_group_id = local.public_id
    security_group_id = aws_security_group.myce_sg.id
}

resource "aws_security_group_rule" "security_3" {
    type = "ingress"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    source_security_group_id = local.public_id
    security_group_id = aws_security_group.myce_sg.id
}

resource "aws_security_group_rule" "security_4" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.myce_sg.id
}