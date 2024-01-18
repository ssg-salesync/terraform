resource "aws_instance" "bastion_host" {
  ami             = "ami-0ff1cd0b5d98708d1"
  instance_type   = "t2.micro"
  subnet_id       = var.subnet_id
  key_name        = aws_key_pair.bastion_key.key_name
  security_groups = [var.bastion_sg_id]
  tags = {
    Name = "bastion"
  }
}


resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "aws_key_pair" "bastion_key" {
  key_name   = "bastion_key"
  public_key = tls_private_key.private_key.public_key_openssh
}


resource "local_file" "private_key" {
  filename = var.private_key_path
  content  = tls_private_key.private_key.private_key_pem
}


output "id" {
  value = aws_instance.bastion_host.id
}
