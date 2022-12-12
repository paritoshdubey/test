# #Proxy VM - instance template
locals {
  compute_instance_template_name_prefix             = "test-${var.region}-"
  compute_region_instance_group_manager_name_prefix = "test-${var.region}-"
  google_compute_region_autoscaler_name_prefix      = "test-${var.region}-"
  vm_template_prefix                                = "ext-${var.environment}-168350-1-cidp-internal-proxy-vms"
  }
  
resource "google_compute_instance_template" "internal_proxy_vm_template" {
  name_prefix = local.compute_instance_template_name_prefix
  description = "This template is used to create internal proxy vm instances."
  project     = var.project
  region      = var.region
  shielded_instance_config {
    enable_secure_boot = true
  }

  tags = ["ext-${var.environment}-168350-1-cidp-internal-proxy-vms"]
  
  labels = {
    owner = "168350-1"
    name  = "proxy-vms"
  }

  instance_description = "test proxy vm"
  machine_type         = "e2-standard-2"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = var.source_image
    auto_delete  = true
    boot         = true
    disk_encryption_key {
      kms_key_self_link = var.disk_encryption_keys
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
  }

  lifecycle {
    create_before_destroy = true
  }

  metadata_startup_script = file("${path.module}/files/startup-script.sh")

  metadata = {
    ENDPOINT           = var.endpoint
    FORWARDING_PORT    = var.forwarding_port
    block-project-ssh-keys = true
    enable-oslogin         = true
  }

  service_account {
    email  = var.google_service_account_instance_template_email
    scopes = ["cloud-platform"]
  }
}

#Need to generate a unique name for instance group
resource "random_id" "internal_compute_region_instance_group_manager" {
  byte_length = 4
  prefix      = local.compute_region_instance_group_manager_name_prefix

  keepers = {
    base_instance_name = google_compute_instance_template.internal_proxy_vm_template.name
  }
}

#Managed instance group of proxy VMs
resource "google_compute_region_instance_group_manager" "internal_instance_group_manager" {
  name               = random_id.internal_compute_region_instance_group_manager.hex
  project            = var.project
  base_instance_name = google_compute_instance_template.internal_proxy_vm_template.name
  region             = var.region
  version {
    instance_template = google_compute_instance_template.internal_proxy_vm_template.id
  }
  named_port {
    name = "https"
    port = "443"
  }
  lifecycle {
    create_before_destroy = true
  }
  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 300
  }
}

resource "random_id" "compute_region_autoscaler" {
  byte_length = 4
  prefix      = local.google_compute_region_autoscaler_name_prefix

  keepers = {
    target = google_compute_region_instance_group_manager.internal_instance_group_manager.id
  }
}


resource "google_compute_region_autoscaler" "cidp" {
  name    = random_id.compute_region_autoscaler.hex
  project = var.project
  region  = var.region
  target  = google_compute_region_instance_group_manager.internal_instance_group_manager.id

  autoscaling_policy {
    max_replicas    = 4
    min_replicas    = 2
    cooldown_period = 90

    cpu_utilization {
      target = 0.75
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_health_check" "autohealing" {
  name                = var.autohealing_hc_name
  provider            = google-beta
  project             = var.project
  check_interval_sec  = 30
  timeout_sec         = 10
  healthy_threshold   = 1
  unhealthy_threshold = 3
  
  
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
