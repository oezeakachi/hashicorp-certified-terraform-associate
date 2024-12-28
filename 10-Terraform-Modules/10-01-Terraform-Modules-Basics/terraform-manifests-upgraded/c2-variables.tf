# Input Variables

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-1"  
} 

variable "key_name_definer" {
  description = ""
  default     = "LL-TEST"
  type        = string
}