# ---------------------------------------------------------------------------------------------------------------------
# SECURITY GROUPS
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc" "quorum-vpc" {
  tags = {
    Name = "${var.environment}-${var.project}-vpc"
  }
}

# EC2
resource "aws_security_group" "quorum-nodes-ct" {
  name_prefix = "${var.environment}-${var.project}-${var.role}-ct-"
  vpc_id      = "${data.aws_vpc.quorum-vpc.id}"

  tags = "${merge(map(
      "Name", "${var.environment}-${var.project}-${var.role}-ct",
      "BuiltWith", "Terraform",
    ), var.extra_tags)}"
}

resource "aws_security_group_rule" "egress-quorum-nodes-ct" {
  type              = "egress"
  security_group_id = "${aws_security_group.quorum-nodes-ct.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress-quorum-nodes-ct-ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.quorum-nodes-ct.id}"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress-quorum-nodes-ct-prometheus" {
  type              = "ingress"
  security_group_id = "${aws_security_group.quorum-nodes-ct.id}"

  from_port   = 9090
  to_port     = 9090
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress-quorum-nodes-ct-grafana" {
  type              = "ingress"
  security_group_id = "${aws_security_group.quorum-nodes-ct.id}"

  from_port   = 3000
  to_port     = 3000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "quorum-nodes" {
  name_prefix = "${var.environment}-${var.project}-${var.role}-"
  vpc_id      = "${data.aws_vpc.quorum-vpc.id}"

  tags = "${merge(map(
      "Name", "${var.environment}-${var.project}-${var.role}",
      "BuiltWith", "Terraform",
    ), var.extra_tags)}"
}

resource "aws_security_group_rule" "egress-quorum-nodes" {
  type              = "egress"
  security_group_id = "${aws_security_group.quorum-nodes.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress-quorum-nodes-ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.quorum-nodes.id}"

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  source_security_group_id = "${aws_security_group.quorum-nodes-ct.id}"
}

resource "aws_security_group_rule" "ingress-quorum-nodes-node-exporter" {
  type              = "ingress"
  security_group_id = "${aws_security_group.quorum-nodes.id}"

  from_port   = 9100
  to_port     = 9100
  protocol    = "tcp"
  source_security_group_id = "${aws_security_group.quorum-nodes-ct.id}"
}

resource "aws_security_group_rule" "ingress-quorum-node-block-exporter" {
  type              = "ingress"
  security_group_id = "${aws_security_group.quorum-nodes.id}"

  from_port   = 8000
  to_port     = 8000
  protocol    = "tcp"
  source_security_group_id = "${aws_security_group.quorum-nodes-ct.id}"
}

resource "aws_security_group_rule" "ingress-quorum-nodes-tessera" {
  type              = "ingress"
  security_group_id = "${aws_security_group.quorum-nodes.id}"

  from_port   = 9001
  to_port     = 9100
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress-quorum-nodes-geth" {
  type              = "ingress"
  security_group_id = "${aws_security_group.quorum-nodes.id}"

  from_port   = 21000
  to_port     = 21100
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

#resource "aws_security_group_rule" "ingress-quorum-nodes-peer-tcp" {
#  type              = "ingress"
#  security_group_id = "${aws_security_group.quorum-nodes.id}"
#
#  from_port   = 30301
#  to_port     = 30351
#  protocol    = "tcp"
#  cidr_blocks = ["0.0.0.0/0"]
#}

#resource "aws_security_group_rule" "ingress-quorum-nodes-peer-udp" {
#  type              = "ingress"
#  security_group_id = "${aws_security_group.quorum-nodes.id}"
#
#  from_port   = 30301
#  to_port     = 30351
#  protocol    = "udp"
#  cidr_blocks = ["0.0.0.0/0"]
#}

#resource "aws_security_group_rule" "ingress-quorum-nodes-rpc" {
#  type              = "ingress"
#  security_group_id = "${aws_security_group.quorum-nodes.id}"
#
#  from_port   = 8543
#  to_port     = 8593
#  protocol    = "tcp"
#  cidr_blocks = ["0.0.0.0/0"]
#}
