output "psa_ranges" {
  description = "Private services accesss address ranges"
  value       = google_compute_global_address.ranges
}

output "psa_connection" {
  description = "Private services access active connections"
  value       = google_service_networking_connection.psa_connection
}

output "db_instances" {
  description = "Test Cloud SQL instances created"
  value       = google_sql_database_instance.db_instances
}
