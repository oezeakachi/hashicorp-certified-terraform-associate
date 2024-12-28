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

# AWS EC2 Instance Module
module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 5.0"

  name                   = "my-modules-demo"

  ami                    = data.aws_ami.amzlinux.id 
  instance_type          = "t2.micro"
  key_name               = "${var.key_name_definer}-key"
  monitoring             = true
  vpc_security_group_ids = ["${aws_security_group.vpc-ssh.id}"] # Get Default VPC Security Group ID and replace
  subnet_id              = "${aws_subnet.vpc-dev-public-subnet-1.id}" # Get one public subnet id from default vpc and replace
  user_data              = file("apache-install.sh") 

# Module Upgrade from v2.x to v5.x 
## In v2.x module, Meta-argument count is used
## In v5.x module, Meta-argument for_each is used
  #instance_count         = 2
  for_each = toset(["one", "two", "three"])

  tags = {
    Name        = "Modules-Demo-${each.key}"
    Terraform   = "true"
    Environment = "dev"
  }
}

