variable "security_groups" {
    type = list(string)
}

variable "prefix" {
    type = string
}

variable "sb"{
    type = map(string)
}

variable "db_pw" {
    type = string
    sensitive = true
}

variable "db_name" {
    type = string
    sensitive = true
}

variable "username" {
    type = string
    sensitive = true
}