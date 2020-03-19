output "bastion_public_ip" {
  value = "${aws_instance.bastion-host.public_ip}"
}
 output "source_security_group_id" {
   value = "${aws_security_group.bastion-sg.id}"
 }