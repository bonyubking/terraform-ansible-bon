variable "instances" {
  type = map(object({
    subnet = string
    sg     = string
    public = bool
  }))
}

variable "key_name" {
  type = string
}

variable "ami" {
  type    = string
  default = "ami-04fcc2023d6e37430"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "prefix" {
  type = string
}

variable "private_rt_id" {
  type = string
}