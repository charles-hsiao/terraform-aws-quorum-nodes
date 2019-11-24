# usage, you should lock the Instances down so they only allow traffic from trusted sources (e.g. the ELB).
# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that supports locking and enforces best
# practices: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

terragrunt = {
  # Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
  # working directory, into a temporary folder, and execute your Terraform commands in that folder.
  terraform {
    source = "../../../../../modules/quorum//quorum-nodes"
  }

  # Include all settings from the root terraform.tfvars file
  include = {
    path = "${find_in_parent_folders()}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
# ---------------------------------------------------------------------------------------------------------------------

role = "quorum-nodes"
ssh_key = "ssh-quorum"

# elasticsearch
es_instance_count = 0  # Elable=1; Disable=0
es_domain = "es-quorum"
es_instance_type = "t2.micro.elasticsearch"

# logstash
logstash_instance_count = 0   # Enable=1; Disable=0
logstash_ami_name = "logstash-ubuntu-1604-*"
logstash_instance_type = "t3.medium"
logstash_root_volume_type = "gp2"
logstash_root_volume_size = "8"
logstash_root_volume_iops = "100"

# quorum-nodes
quorum_ami_name = "quorum-ubuntu-1604-*"
instance_min_size = 1
instance_max_size = 7
instance_desired_capacity = 5
nodes_instance_type = "t3.medium"
nodes_root_volume_type = "gp2"
nodes_root_volume_size = "8"
nodes_root_volume_iops = "100"

# quorum-nodes-ct
ct_ami_name = "quorum-ct-ubuntu-1604-*"
ct_instance_type = "t3.large"
ct_root_volume_type = "gp2"
ct_root_volume_size = "8"
ct_root_volume_iops = "100"

extra_tags = {
  Project = "quorum"
  Environment = "stag"
}

autoscaling_group_extra_tags = [
  { key = "Project", value = "quorum", propagate_at_launch = true },
  { key = "Environment", value = "stag", propagate_at_launch = true },
  { key = "Role", value = "quorum-nodes", propagate_at_launch = true }
]
