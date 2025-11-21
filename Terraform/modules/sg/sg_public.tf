resource "aws_security_group" "myce_sg_public" {
    name = "${var.sc_name_prefix}-sg-public"
    vpc_id = var.vpc_id        
}


resource "aws_security_group_rule" "public_security_1" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.myce_sg_public.id
}

resource "aws_security_group_rule" "public_security_2" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.myce_sg_public.id
}

resource "aws_security_group_rule" "public_security_3" {
    type = "ingress"
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.myce_sg_public.id
}

resource "aws_security_group_rule" "public_security_4" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.myce_sg_public.id
}