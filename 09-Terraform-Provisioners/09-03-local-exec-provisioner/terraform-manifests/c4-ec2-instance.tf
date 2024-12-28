## Output variables


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
resource "aws_instance" "my-ec2-vm" {
  ami           = data.aws_ami.amzlinux.id 
  instance_type = var.instance_type
  key_name               = "${var.key_name_definer}-key"
  subnet_id              = aws_subnet.vpc-dev-public-subnet-1.id
  #count = terraform.workspace == "default" ? 1 : 1    
	user_data = file("apache-install.sh")  
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]
  tags = {
    "Name" = "vm-${terraform.workspace}-0"
  }

  # local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)
  provisioner "local-exec" {
    command = "echo ${aws_instance.my-ec2-vm.private_ip} >> creation-time-private-ip.txt"
    working_dir = "local-exec-output-files/"
    #on_failure = continue
  }

  # local-exec provisioner - (Destroy-Time Provisioner - Triggered during Destroy Resource)
  provisioner "local-exec" {
    when    = destroy
    command = "echo Destroy-time provisioner Instanace Destroyed at `date` >> destroy-time.txt"
    working_dir = "local-exec-output-files/"
  }  

}







