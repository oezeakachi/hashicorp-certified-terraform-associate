# Input Variables
variable "aws_region" {
  description = "Region in which AWS resources to be created"
  type        = string
  default     = "eu-west-1"
}

variable "ec2_ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-07d4917b6f95f5c2a" # Red Hat, Inc
}

variable "ec2_instance_count" {
  description = "EC2 Instance Count"
  type        = number
  default     = 1
}

# Assign When Prompted using CLI
variable "ec2_instance_type" {
  description = "EC2 Instance Type"
  type = string
}