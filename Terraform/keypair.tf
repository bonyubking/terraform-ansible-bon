
resource "aws_key_pair" "myce_keypair" {
  key_name   = "terra_myce_keypair"
  public_key = file("./pulic_key.pub")
}

