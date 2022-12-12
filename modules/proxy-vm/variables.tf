variable "network" {
  type        = string
  description = "Network for Apigee Internal"
}

variable "subnetwork" {
  type        = string
  description = "Subnet for Internal Load Balancing"
}

variable "region" {
  type        = string
  description = "Primary region for Internal Cloud API Management"
}

variable "project" {
  type        = string
  description = "The project id"
}

variable "google_service_account_instance_template_email" {
  type        = string
  description = "The google service account to manage vms"
}

variable "endpoint" {
  type        = string
  default     = ""
  description = "The endpoint metadata"
}

variable "source_image" {
  type        = string
  description = "The source image of the instance template, e.g. centos-cloud/centos-7"
}

variable "autohealing_hc_name" {
  type        = string
  description = "Name of the autohealing healthcheck"
}

variable "forwarding_port" {
  type = number
  description = "The TCP listening and forwarding port "
}

variable "environment" {
  type = string
  description = "Environment in which VM will deployed "
}

variable "disk_encryption_keys" {
  type        = string
  description = "The kms keys to encrypt vm disk"
}
