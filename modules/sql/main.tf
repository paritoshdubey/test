/**
 * # Terraform module for DB Cloud SQL private services access setup
 */

resource "google_compute_global_address" "ranges" {
  provider = google-beta
  for_each = local.address_ranges

  name          = each.key
  purpose       = "VPC_PEERING"
  project       = var.project_id
  address_type  = "INTERNAL"
  address       = each.value.address
  prefix_length = each.value.prefix_length
  network       = var.network
}

resource "google_service_networking_connection" "psa_connection" {
  provider = google-beta

  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [for range in google_compute_global_address.ranges : range.name]
}

resource "random_string" "db_random" {
  for_each = local.db_instances

  special = false
  upper   = false
  length  = 4
}

resource "google_sql_database_instance" "db_instances" {
  for_each = local.db_instances
  provider = google-beta

  name             = format("%s-%s", each.key, random_string.db_random[each.key])
  region           = each.value
  database_version = var.kind == "psql" ? "POSTGRES_12" : "MYSQL_5_7"

  depends_on = [google_service_networking_connection.psa_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false # No public IP address
      private_network = var.network
    }
  }
}
