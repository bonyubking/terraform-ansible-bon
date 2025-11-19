resource "aws_security_group" "myce_sg_bastion" {
    name = "terra_bastion_sg"
    vpc_id = var.vpc_id       
}


resource "aws_security_group_rule" "bastion_security_1" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.myce_sg_bastion.id
}

resource "aws_security_group_rule" "bastion_security_2" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.myce_sg_bastion.id
}