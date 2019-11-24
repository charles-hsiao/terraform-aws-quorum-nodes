# CT EIP
output "CT IP" {
  description = "IP of CT server"
  value       = "${aws_eip.quorum-nodes-ct.public_ip}"
}

# Elasticsearch
output "ES endpoint" {
  description = "Domain-specific endpoint used to submit index, search, and data upload requests"
  value       = ["${aws_elasticsearch_domain.es.*.endpoint}"]
}

output "Kibana endpoint" {
  description = "Domain-specific endpoint for kibana without https scheme"
  value       = ["${aws_elasticsearch_domain.es.*.kibana_endpoint}"]
}
