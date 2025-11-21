variable "name_prefix" {
    type = string
}

variable "vpc_cidr" {
  type = string
}

variable "subnets" {
  type = map(object({
    cidr = string
    az   = string
    public = bool
  }))
}