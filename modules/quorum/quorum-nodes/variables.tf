variable "aws_region" {}
variable "aws_profile" {}
variable "environment" {}
variable "project" {}

variable "role" {}
variable "ssh_key" {}

# elasticsearch
variable "es_instance_count" {}
variable "es_domain" {}
variable "es_version" {}
variable "es_instance_type" {}
variable "es_ebs_volume_size" {}
variable "es_ebs_volume_type" {}

# logstash
variable "logstash_instance_count" {}
variable "logstash_ami_name" {}
variable "logstash_instance_type" {}
variable "logstash_root_volume_type" {}
variable "logstash_root_volume_size" {}
variable "logstash_root_volume_iops" {}

# quorum-nodes
variable "quorum_ami_name" {}
variable "instance_min_size" {}
variable "instance_max_size" {}
variable "instance_desired_capacity" {}
variable "nodes_instance_type" {}
variable "nodes_root_volume_type" {}
variable "nodes_root_volume_size" {}
variable "nodes_root_volume_iops" {}

# quorum-nodes-ct
variable "ct_ami_name" {}
variable "ct_instance_type" {}
variable "ct_root_volume_type" {}
variable "ct_root_volume_size" {}
variable "ct_root_volume_iops" {}

variable "extra_tags" {
  type = "map"
}
variable "autoscaling_group_extra_tags" {
  type = "list"
}
