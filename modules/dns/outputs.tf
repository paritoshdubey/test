/*
"Copyright 2021 by Google. Your use of any copyrighted material and any warranties, if applicable, are subject to your agreement with Google."
*/

output "endpoints" {
  description = "Endpoint resources."
  value       = google_service_directory_endpoint.default
}

output "services" {
  description = "Service resources."
  value       = google_service_directory_service.default
}
