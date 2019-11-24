# ---------------------------------------------------------------------------------------------------------------------
# ELASTICSEARCH SERVICE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "es" {
  count                 = "${var.es_instance_count}"
  domain_name           = "${var.es_domain}"
  elasticsearch_version = "${var.es_version}"

  depends_on = ["aws_iam_service_linked_role.es"]

  cluster_config {
    instance_type            = "${var.es_instance_type}"
    instance_count           = "${var.es_instance_count}"
    dedicated_master_enabled = false
  }

  ebs_options {
    ebs_enabled = "${var.es_ebs_volume_size > 0 ? true : false}"
    volume_size = "${var.es_ebs_volume_size}"
    volume_type = "${var.es_ebs_volume_type}"
  }

access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.es_domain}/*"
        }
    ]
}
CONFIG

  tags = "${merge(map(
    "Name", "${var.environment}-${var.project}-${var.role}-es",
    "Role", "elasticsearch",
    "BuiltWith", "Terraform",
  ), var.extra_tags)}"
}
