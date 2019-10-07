# EIP
output "elastic ip" {
  value = "${aws_eip.quorum-nodes-ct.public_ip}"
}
