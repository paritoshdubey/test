data "google_project" "project" {
  project_id = var.project
}

data "google_compute_subnetwork" "subnetwork" {
  self_link = var.subnetwork_self_link
}

locals {
  node_pool_defaults = {
    node_count                  = 1
    autoscaling                 = true
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    disk_type                   = "pd-ssd"
    disk_size_gb                = 100
    max_pods_per_node           = var.default_max_pods_per_node
    image_type                  = "COS_CONTAINERD"
    max_surge                   = 2
    boot_disk_kms_key           = var.boot_disk_kms_key_id
    node_metadata               = "GKE_METADATA"

  }
  merged_master_authorized_networks = var.master_authorized_networks
}

module "cluster" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  version = "23.1.0"

  # Cluster settings
  project_id                    = var.project
  name                          = var.name
  regional                      = true
  region                        = data.google_compute_subnetwork.subnetwork.region
  zones                         = var.zones
  remove_default_node_pool      = true
  service_account               = var.service_account_email
  grant_registry_access         = false
  create_service_account        = false
  horizontal_pod_autoscaling    = false
  deploy_using_private_endpoint = true
  enable_private_endpoint       = true
  master_global_access_enabled  = true
  enable_shielded_nodes         = true
  identity_namespace            = "enabled"
  maintenance_start_time        = "01:00"
  maintenance_end_time          = "05:00"
  release_channel               = "REGULAR"
  enable_private_nodes          = true
  enable_binary_authorization   = true
  network_policy                = var.datapath_provider == "ADVANCED_DATAPATH" ? false : var.network_policy # Mutally exclusive to dataplane v2
  sandbox_enabled               = false
  skip_provisioners             = true
  disable_default_snat          = true
  default_max_pods_per_node     = var.default_max_pods_per_node
  enable_pod_security_policy    = false # Disabled because we're using Anthos Config Management Policy Controller instead
  # authenticator_security_group  = "gke-security-groups@db.com" # Todo: Enable once it is there
  gce_pd_csi_driver             = var.gce_pd_csi_driver
  datapath_provider             = var.datapath_provider

  issue_client_certificate = var.issue_client_certificate

  cluster_dns_provider          = "CLOUD_DNS"
  cluster_dns_scope             = "VPC_SCOPE"
  cluster_dns_domain            = var.cluster_domain

  database_encryption = [{
    state    = "ENCRYPTED"
    key_name = module.kubernetes_disk_cryptokey_europe_west3.key_id
  }]

  cluster_resource_labels = {
    mesh_id = "proj-${data.google_project.project.number}"
  }

  # Node Pool settings
  node_pools                  = [for name, options in var.node_pools : merge(local.node_pool_defaults, { name = name }, options)]
  enable_intranode_visibility = true

  node_pools_labels = var.node_pools_labels
  node_pools_tags   = var.node_pools_tags

  node_pools_metadata = {
    all = {
      "block-project-ssh-keys"   = "TRUE" # TRUE -> https://webcache.googleusercontent.com/search?q=cache%3AeoOZofJymfIJ%3Ahttps%3A%2F%2Fcloud.google.com%2Fcompute%2Fdocs%2Finstances%2Fadding-removing-ssh-keys%20&cd=1&hl=en&ct=clnk&gl=de#block-project-keys
      "disable-legacy-endpoints" = "true" # true -> https://cloud.google.com/kubernetes-engine/docs/how-to/protecting-cluster-metadata#create-disabled
    }
  }

  # Network settings
  network_project_id         = data.google_compute_subnetwork.subnetwork.project
  network                    = regex("global/networks/(.*)$", data.google_compute_subnetwork.subnetwork.network)[0]
  subnetwork                 = regex("subnetworks/(.*)$", var.subnetwork_self_link)[0] # Using regex instead of data source to avoid a Terraform bug
  ip_range_pods              = var.secondary_range_name_pods
  ip_range_services          = var.secondary_range_name_services
  master_ipv4_cidr_block     = var.master_ipv4_cidr_block
  master_authorized_networks = [for name in sort(keys(local.merged_master_authorized_networks)) : { display_name = name, cidr_block = local.merged_master_authorized_networks[name] }]

  # IP Masq settings
  # We agreed on configuring everything Kubernetes related not from TFE. Therefore this is deactivated
  configure_ip_masq = false
  # non_masquerade_cidrs = []
}
