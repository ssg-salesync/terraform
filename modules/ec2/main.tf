resource "aws_instance" "bastion_host" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}