output "master_version" {
  value       = module.cluster.master_version
  description = "Current master kubernetes version"
}

output "name" {
  value       = module.cluster.name
  description = "Cluster name"
}

output "location" {
  value       = module.cluster.location
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
}

output "min_total_node_count" {
  # Note: For simplicity, this implementation assumes the zones of the node pools to be identical to the cluster's zones
  value       = sum([for name, np in var.node_pools : tonumber(np.min_count)]) * length(var.zones)
  description = "The minimum number of nodes of the cluster. All node pools are included. Nodes in each zone count."
}

output "max_total_node_count" {
  # Note: For simplicity, this implementation assumes the zones of the node pools to be identical to the cluster's zones
  value       = sum([for name, np in var.node_pools : tonumber(np.max_count)]) * length(var.zones)
  description = "The maximum number of nodes of the cluster. All node pools are included. Nodes in each zone count."
}

output "gke_hub_membership_id" {
  value       = var.enable_gke_hub_registration ? google_gke_hub_membership.membership.0.membership_id : ""
  description = "The GKE Hub membership id of the cluster. Contains empty string if the cluster has no membership"
}
