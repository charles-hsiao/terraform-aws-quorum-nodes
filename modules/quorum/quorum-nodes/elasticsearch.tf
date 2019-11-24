# ---------------------------------------------------------------------------------------------------------------------
# ELASTICSEARCH SERVICE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "es" {
  count                 = "${var.es_instance_count}" 
  domain_name           = "${var.es_domain}"
  elasticsearch_version = "6.3"

  cluster_config {
    instance_type = "${var.es_instance_type}"
  }

  vpc_options {
    subnet_ids = ["${element(data.aws_subnet_ids.quorum-public.ids, count.index)}"]

    security_group_ids = ["${aws_security_group.es.id}"]
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
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

  depends_on = [
    "aws_iam_service_linked_role.es",
  ]
}
