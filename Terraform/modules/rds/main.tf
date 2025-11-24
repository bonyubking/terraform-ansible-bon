resource "aws_db_instance" "terra-mysql" {
  
  allocated_storage = 20
  storage_type = "standard"
  engine = "mysql"
  engine_version = "8.0.43"
  instance_class = "db.t3.micro"
  identifier = "${var.prefix}-terra-mysql"
  db_name = var.db_name
  username = var.username
  password = var.db_pw
  availability_zone = "ap-northeast-2a"
  db_subnet_group_name = aws_db_subnet_group.mysql-terra.id
  vpc_security_group_ids = var.security_groups
  skip_final_snapshot = true

}

resource "aws_db_subnet_group" "mysql-terra" {
    name = "${var.prefix}-sb-mysql"
    subnet_ids = values(var.sb)
}