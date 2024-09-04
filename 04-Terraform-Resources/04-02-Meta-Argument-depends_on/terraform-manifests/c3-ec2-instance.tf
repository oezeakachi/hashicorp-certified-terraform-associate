## SSH Key Creation

## Output variables
output "ssh_keypair" {
  value = tls_private_key.key.private_key_pem
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
############################################################

# Resource-8: Create EC2 Instance
resource "aws_instance" "my-ec2-vm" {
  ami                    = "ami-07d4917b6f95f5c2a" # Amazon Linux
  instance_type          = "t2.micro"
  key_name               = "${var.key_name_definer}-key"
  subnet_id              = aws_subnet.vpc-dev-public-subnet-1.id
  vpc_security_group_ids = [aws_security_group.dev-vpc-sg.id]
  #user_data = file("apache-install.sh")
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<h1>Welcome to StackSimplify ! AWS Infra created using Terraform in us-east-1 Region</h1>" > /var/www/html/index.html
    EOF
  tags = {
    "Name" = "myec2vm"

  }    
}



