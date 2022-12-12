output "group_manager_instance_group" {
  value = google_compute_region_instance_group_manager.internal_instance_group_manager.instance_group
}
output "google_compute_instance_template_name" {
  value = google_compute_instance_template.internal_proxy_vm_template.name  
}
output "google_compute_instance_template_id" {
  value = google_compute_instance_template.internal_proxy_vm_template.id  
}

