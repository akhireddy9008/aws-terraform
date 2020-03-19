
resource "aws_instance" "bastion-host" {
  ami                         = var.ami
  key_name                    = "${aws_key_pair.bastion_key.key_name}"
  instance_type               = var.instance_type
  security_groups             = ["${aws_security_group.bastion-sg.id}"]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
}

resource "aws_security_group" "bastion-sg" {
  name   = "bastion-security-group-sg"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0 
    to_port     = 0 
    cidr_blocks = ["0.0.0.0/0"]
  }
   
}

resource "aws_key_pair" "bastion_key" {
  key_name   = var.key_name
  public_key = var.public_key

}