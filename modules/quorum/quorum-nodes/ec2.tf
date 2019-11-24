# ---------------------------------------------------------------------------------------------------------------------
# EC2
# ---------------------------------------------------------------------------------------------------------------------

# Control Tower(Experiment Server) & SSH Gateway
resource "aws_instance" "quorum-nodes-ct" {
  count                  = 1
  ami                    = "${data.aws_ami.ami-quorum-nodes-ct.id}"
  instance_type          = "${var.ct_instance_type}"
  key_name               = "${var.ssh_key}"
  vpc_security_group_ids = [ "${aws_security_group.quorum-nodes-ct.id}" ]
  subnet_id              = "${element(data.aws_subnet_ids.quorum-public.ids, count.index)}"
  monitoring             = false

  root_block_device {
    volume_type = "${var.ct_root_volume_type}"
    volume_size = "${var.ct_root_volume_size}"
    iops        = "${var.ct_root_volume_type == "io1" ? var.ct_root_volume_iops : 0}"
  }

  tags = "${merge(map(
    "Name", "${var.environment}-${var.project}-${var.role}-ct",
    "Role", "${var.role}-ct",
    "BuiltWith", "Terraform",
  ), var.extra_tags)}"

  volume_tags = "${merge(map(
    "Name", "${var.environment}-${var.project}-${var.role}-ct",
    "Role", "${var.role}-ct",
    "BuiltWith", "Terraform",
  ), var.extra_tags)}"
}

data "aws_ami" "ami-quorum-nodes-ct" {
  most_recent = true
  owners      = ["${data.aws_caller_identity.current.account_id}"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["${var.ct_ami_name}"]
  }
}

# Logstash
resource "aws_instance" "logstash" {
  count                  = "${var.logstash_instance_count}"
  ami                    = "${data.aws_ami.ami-logstash.id}"
  instance_type          = "${var.logstash_instance_type}"
  key_name               = "${var.ssh_key}"
  vpc_security_group_ids = [ "${aws_security_group.logstash.id}" ]
  subnet_id              = "${element(data.aws_subnet_ids.quorum-public.ids, count.index)}"
  monitoring             = false

  root_block_device {
    volume_type = "${var.logstash_root_volume_type}"
    volume_size = "${var.logstash_root_volume_size}"
    iops        = "${var.logstash_root_volume_type == "io1" ? var.logstash_root_volume_iops : 0}"
  }

  tags = "${merge(map(
    "Name", "${var.environment}-${var.project}-${var.role}-logstash",
    "Role", "logstash",
    "BuiltWith", "Terraform",
  ), var.extra_tags)}"

  volume_tags = "${merge(map(
    "Name", "${var.environment}-${var.project}-${var.role}-logstash",
    "Role", "logstash",
    "BuiltWith", "Terraform",
  ), var.extra_tags)}"
}

data "aws_ami" "ami-logstash" {
  most_recent = true
  owners      = ["${data.aws_caller_identity.current.account_id}"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["${var.logstash_ami_name}"]
  }
}
