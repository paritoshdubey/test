module "internal_proxy_vm_tcp" {
  source   = "./modules/proxy-vm"

  project                                        = local.cluster_project_id
  region                                         = "europe-west3"
  network                                        = var.germany_network
  environment                                    = var.environment
  subnetwork                                     = var.germany_subnetwork
  endpoint                                       = google_compute_address.cidp-internal-static-ip.address
  google_service_account_instance_template_email = data.terraform_remote_state.sensitive_state_a.outputs.cluster_nodes_service_account_email
  source_image                                   = "rhel-cloud/rhel-7"
  autohealing_hc_name                            = "hc-autoheal-lvl1-euw3"
  forwarding_port                                = "443"
  disk_encryption_keys                           = local.disk_encryption_keys 
}



resource "google_compute_region_backend_service" "internal_ilb_backend" {
  name                  = "test-proxy-backend-service"
  project               = local.cluster_project_id
  region                = "europe-west3"
  protocol              = "TCP"
  load_balancing_scheme = "INTERNAL"
  timeout_sec           = 30
  health_checks         = [google_compute_health_check.internal_hc.id]
  backend {
    group           = module.internal_proxy_vm_tcp.group_manager_instance_group
    balancing_mode  = "CONNECTION"
  }
  lifecycle {
    create_before_destroy = true
  }
}



resource "google_compute_health_check" "internal_hc" {
  name               = "check-tcp-ilb-backend"
  check_interval_sec = 30
  timeout_sec        = 10
  project            = local.cluster_project_id

  
  #tcp_health_check {
  #  port = "443"
  #}
  https_health_check {
    port         = "443"
    request_path = "/healthz"
  }
  
  log_config {
    enable = true
  }
}
