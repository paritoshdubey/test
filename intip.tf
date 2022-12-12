## Internal ingress

resource "google_compute_address" "internal-static-ip" {
  provider      = google-beta
  project       = module.cluster_project.project_id
  name          = "internal-static-ip"
  address_type  = "INTERNAL"
  subnetwork    = var.germany_subnetwork
  region        = "europe-west3"
}

