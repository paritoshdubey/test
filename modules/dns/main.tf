/*
"Copyright 2021 by Google. Your use of any copyrighted material and any warranties, if applicable, are subject to your agreement with Google."
*/

locals {
transformed_config = toset(flatten([
  for service_key, record in var.config : [
    for endpoint_key, endpoint_details in record : {
      service_name = service_key
      endpoint_name = endpoint_key
      endpoint_address = endpoint_details.address
      endpoint_port = endpoint_details.port
  } ] ] ) )
}

resource "google_service_directory_service" "default" {
  provider   = google-beta
  for_each   = var.config
  namespace  = var.namespace
  service_id = each.key
}


resource "google_service_directory_endpoint" "default" {
  for_each = {for endpoint in local.transformed_config : "${endpoint.service_name}-${endpoint.endpoint_name}" => endpoint}
  provider    = google-beta
  endpoint_id = each.value.endpoint_name
  service     = google_service_directory_service.default[each.value.service_name].id
  address     = each.value.endpoint_address
  port        = each.value.endpoint_port
}
