# Define Output Values

output "ssh_keypair" {
  value = tls_private_key.key.private_key_pem
  sensitive = true
}


output "key_name" {
  value = aws_key_pair.key_pair.key_name
  
}


# Attribute Reference
output "ec2_instance_publicip" {
  description = "EC2 Instance Public IP"
  value = aws_instance.my-ec2-vm.*.public_ip
}


# Attribute Reference - Create Public DNS URL 
output "ec2_publicdns" {
  description = "Public DNS URL of an EC2 Instance"
  value = aws_instance.my-ec2-vm.*.public_dns
}
