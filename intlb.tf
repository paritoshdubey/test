resource "google_compute_forwarding_rule" "default" {
  name                  = "internal-tcp-forwarding-rule-euw3"
  region                = "europe-west3"
  project               = local.cluster_project_id
  load_balancing_scheme = "INTERNAL"
  ip_address            = google_compute_address.internal-static-ip.address
  ip_protocol           = "TCP"
  ports                 = ["443"]
  allow_global_access   = true
  network               = var.germany_network
  subnetwork            = var.germany_subnetwork
  service_label         = "ilb"
  backend_service       = google_compute_region_backend_service.internal_ilb_backend.self_link
}

