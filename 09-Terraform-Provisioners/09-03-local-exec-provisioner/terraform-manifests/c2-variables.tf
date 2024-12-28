# Input Variables
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type = string
  default = "eu-west-1"
}

variable "key_name_definer" {
  description = ""
  default     = "LL-TEST"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type - Instance Sizing"
  type = string
  default = "t2.micro"
  #default = "t2.small"
}