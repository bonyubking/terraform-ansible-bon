variable "subnet_id" {
  type = string
}

variable "ami" {
  type    = string
  default = "ami-04fcc2023d6e37430"   # 원하는 기본 AMI
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "security_group_ids" {
  type    = list(string)
}

variable "key_name" {
    type = string
}

variable "use_public_ip" {
  type    = bool
  default = true
}

variable "name" {
  type = string
}
