#
# ELK Master EC2 Instance
#
# https://www.terraform.io/docs/providers/aws/r/instance.html
resource "aws_instance" "elk_ec2" {
  key_name      = "${var.key_name}"
  ami           = "${var.elk_ami_id}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${var.iam_profile_parameter_store-name}"

  subnet_id                   = "${element(var.public_subnet_ids, 0)}"
  associate_public_ip_address = false
  vpc_security_group_ids      = [
    "${var.sg_ssh_from_bastion-id}",
    "${var.sg_tcp_to_elk-id}"
  ]
  user_data                   = "${file("./elk/userdata.sh")}"

  tags = {
    Name = "tf_elk-ec2"
  }
}

output "elk_ec2-id" {
  value = "${aws_instance.elk_ec2.id}"
}

output "elk_ec2-private_ip" {
  value = "${aws_instance.elk_ec2.private_ip}"
}