  module "cluster" {
  source  = "./modules/gke"
  #version = "4.0.0"

  project                = module.cluster_project.project_id
  name                   = var.germany_cluster_name
  zones                  = var.germany_zones
  subnetwork_self_link   = var.germany_subnet_self_link
  master_ipv4_cidr_block = var.germany_master_cidr_range
  service_account_email  = module.cluster_workload_service_accounts.service_account_email
  database_crypto_key_id = module.kubernetes_secrets_cryptokey_europe_west3.key_id
  boot_disk_kms_key_id   = module.kubernetes_secrets_disk_europe_west3.key_id
  
  
  enable_gke_hub_registration = true
  enable_policy_controller    = false
  enable_binauthz             = false
  gce_pd_csi_driver           = true
  cluster_domain              = var.cluster_domain
  
  node_pools = {
    "test" = {
      min_count     = var.germany_node_ds_min_count
      max_count     = var.germany_node_ds_max_count
      machine_type  = var.germany_node_ds_machine_type
      preemptible   = var.germany_node_ds_preemptible
  }

  
    
  node_pools_tags = {
    all = var.baseline_tags   
    }
       
}
