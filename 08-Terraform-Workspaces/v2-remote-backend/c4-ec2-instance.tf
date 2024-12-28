## SSH Key Creation

## Output variables
output "ssh_keypair" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}


output "key_name" {
  value = aws_key_pair.key_pair.key_name

}

## variable definition
variable "key_name_definer" {
  description = ""
  default     = "LL-TEST"
  type        = string
}


## Key Pair Creation#######################################
resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_file" "private_key" {
  filename          = "${var.key_name_definer}-key.pem"
  sensitive_content = tls_private_key.key.private_key_pem
  file_permission   = "0400"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.key_name_definer}-key"
  public_key = tls_private_key.key.public_key_openssh
}



# Create EC2 Instance - Amazon Linux
resource "aws_instance" "my-ec2-vm-OBI" {
  ami                    = data.aws_ami.amzlinux.id
  instance_type          = var.instance_type
  key_name               = "${var.key_name_definer}-key"
  subnet_id              = aws_subnet.vpc-dev-public-subnet-1.id
  count                  = terraform.workspace == "default" ? 2 : 1
  user_data              = file("apache-install.sh")
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
  tags = {
    "Name" = "vm-${terraform.workspace}-${count.index}"
  }
}

