locals {
    private_id = aws_security_group.myce_sg.id
    bastion_id2 = aws_security_group.myce_sg_bastion.id
}


resource "aws_security_group" "myce_sg_mysql" {
    name  = "${var.sc_name_prefix}-sg-rds"
    vpc_id = var.vpc_id

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [
            local.private_id, local.bastion_id2  
        ]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

